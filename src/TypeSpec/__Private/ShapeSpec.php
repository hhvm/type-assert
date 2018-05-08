<?hh // strict
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
use namespace HH\Lib\{C, Dict};

final class ShapeSpec extends TypeSpec<shape()> {
  const bool STRICT_SHAPES = \HHVM_VERSION_ID >= 32300;
  private bool $allowUnknownFields;

  private static function isOptionalField<Tany>(TypeSpec<Tany> $spec): bool {
    if ($spec->isOptional()) {
      return true;
    }
    if (self::STRICT_SHAPES) {
      return false;
    }
    return $spec instanceof NullableSpec;
  }

  public function __construct(
    private dict<string, TypeSpec<mixed>> $inners,
    UnknownFieldsMode $unknown_fields,
  ) {
    $this->allowUnknownFields = $unknown_fields === UnknownFieldsMode::ALLOW;
  }

  public function coerceType(mixed $value): shape() {
    if (!$value instanceof KeyedTraversable) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'shape', $value);
    }

    $value = dict($value);
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

  public function assertType(mixed $value): shape() {
    if (!(is_array($value) || is_dict($value))) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), 'shape', $value);
    }
    assert($value instanceof KeyedContainer);

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
    dict<string, mixed> $shape,
  ): shape() {
    if (is_dict(shape())) {
      /* HH_IGNORE_ERROR[4110] */
      return $shape;
    }
    /* HH_IGNORE_ERROR[4007] */
    return (array)$shape;
  }
}
