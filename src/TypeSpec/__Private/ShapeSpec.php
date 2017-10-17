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
      $trace = $this->getTrace()->withFrame('shape['.$key.']');
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec->withTrace($trace)->coerceType($value[$key] ?? null);
        continue;
      }

      if ($spec->isOptional()) {
        continue;
      }

      try {
        $spec->withTrace($trace)->coerceType(null);
      } catch (TypeCoercionException $e) {
        throw new TypeCoercionException(
          $trace,
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

      if ($spec->isOptional()) {
        continue;
      }

      try {
        $spec->withTrace($trace)->assertType(null);
      } catch (IncorrectTypeException $e) {
        throw new IncorrectTypeException(
          $trace,
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
