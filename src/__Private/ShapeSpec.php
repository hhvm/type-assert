<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\{C, Dict};

final class ShapeSpec extends TypeSpec<shape()> {

  public function __construct(private dict<string, TypeSpec<mixed>> $inners) {
  }

  public function coerceType(mixed $value): shape() {
    if (!$value instanceof KeyedTraversable) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'shape', $value);
    }

    $value = dict($value);
    $out = dict[];
    foreach ($this->inners as $key => $spec) {
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec
          ->withTrace($this->getTrace()->withFrame('shape['.$key.']'))
          ->coerceType($value[$key] ?? null);
        continue;
      }

      try {
        $spec->coerceType(null);
      } catch (TypeCoercionException $e) {
        throw new TypeCoercionException(
          $this->getTrace(),
          $e->getTargetType(),
          'missing shape field',
        );
      }
    }
    foreach ($value as $k => $v) {
      if (!C\contains_key($out, $k)) {
        $out[$k] = $v;
      }
    }

    return self::dictToShapeUNSAFE($out);
  }

  public function assertType(mixed $value): shape() {
    if (is_array($value)) {
      $value = Dict\pull_with_key(
        $value,
        ($_k, $v) ==> $v,
        ($k, $_v) ==> (new StringSpec())->assertType($k),
      );
    } else if (is_dict($value)) {
      $value = dict(
        (new DictSpec(new StringSpec(), new MixedSpec()))->assertType($value),
      );
    } else {
      throw
        IncorrectTypeException::withValue($this->getTrace(), 'shape', $value);
    }

    $out = dict[];
    foreach ($this->inners as $key => $spec) {
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec
          ->withTrace($this->getTrace()->withFrame('shape['.$key.']'))
          ->assertType($value[$key] ?? null);
        continue;
      }

      try {
        $spec->assertType(null);
      } catch (IncorrectTypeException $e) {
        throw new IncorrectTypeException(
          $this->getTrace(),
          $e->getExpectedType(),
          'missing shape field ("'.$key.'")',
        );
      }
    }
    foreach ($value as $k => $v) {
      if (!C\contains_key($out, $k)) {
        $out[$k] = $v;
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
