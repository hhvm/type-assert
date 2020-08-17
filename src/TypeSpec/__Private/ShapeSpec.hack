/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\{C, Dict, Str, Vec};

final class ShapeSpec extends TypeSpec<shape()> {
  private bool $allowUnknownFields;

  private static function isOptionalField<Tany>(TypeSpec<Tany> $spec): bool {
    return $spec->isOptional();
  }

  public function __construct(
    private dict<string, TypeSpec<mixed>> $inners,
    UnknownFieldsMode $unknown_fields,
  ) {
    $this->allowUnknownFields = $unknown_fields === UnknownFieldsMode::ALLOW;
  }

  <<__Override>>
  public function coerceType(mixed $value): shape() {
    if (!$value is KeyedTraversable<_, _>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'shape',
        $value,
      );
    }

    $value = dict(/* HH_IGNORE_ERROR[4323] */$value);
    $out = dict[];
    foreach ($this->inners as $key => $spec) {
      $trace = $this->getTrace()->withFrame('shape['.$key.']');
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec->withTrace($trace)->coerceType($value[$key] ?? null);
        continue;
      }

      if (self::isOptionalField($spec)) {
        continue;
      }

      throw new TypeCoercionException($trace, 'value', 'missing shape field');
    }

    if ($this->allowUnknownFields) {
      foreach ($value as $k => $v) {
        if (!C\contains_key($out, $k)) {
          $out[$k] = $v;
        }
      }
    }

    return self::dictToShapeUNSAFE($out);
  }

  <<__Override>>
  public function assertType(mixed $value): shape() {
    if (!(\HH\is_php_array($value) || ($value is dict<_, _>))) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'shape',
        $value,
      );
    }
    assert($value is KeyedContainer<_, _>);

    $out = dict[];
    foreach ($this->inners as $key => $spec) {
      $trace = $this->getTrace()->withFrame('shape['.$key.']');
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec->withTrace($trace)->assertType($value[$key] ?? null);
        continue;
      }

      if (self::isOptionalField($spec)) {
        continue;
      }

      throw new IncorrectTypeException(
        $trace,
        'value',
        'missing shape field ("'.$key.'")',
      );
    }
    foreach ($value as $k => $v) {
      if (!C\contains_key($out, $k)) {
        if ($this->allowUnknownFields) {
          $out[$k] = $v;
        } else {
          throw IncorrectTypeException::withValue(
            $this->getTrace()->withFrame('shape['.$k.']'),
            'no extra shape fields',
            $v,
          );
        }
      }
    }

    return self::dictToShapeUNSAFE($out);
  }

  private static function dictToShapeUNSAFE(
    dict<arraykey, mixed> $shape,
  ): shape() {
    if (shape() is dict<_, _>) {
      /* HH_IGNORE_ERROR[4110] */
      return $shape;
    }
    return /* HH_IGNORE_ERROR[4110] */ darray($shape);
  }

  <<__Override>>
  public function toString(): string {
    return $this->inners
      |> Dict\map_with_key(
        $$,
        ($name, $spec) ==> Str\format(
          "  %s'%s' => %s,",
          $spec->isOptional() ? '?' : '',
          $name,
          $spec->toString(),
        ),
      )
      |> $this->allowUnknownFields ? Vec\concat($$, vec['  ...']) : $$
      |> Str\join($$, "\n")
      |> "shape(\n".$$."\n)";
  }
}
