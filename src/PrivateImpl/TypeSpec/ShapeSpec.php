<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert\PrivateImpl\TypeSpec;

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException
};

use namespace HH\Lib\C;

final class ShapeSpec implements TypeSpec<array<string, mixed>> {

  public function __construct(
    private dict<string, TypeSpec<mixed>> $inners,
  ) {
  }

  public function coerceType(mixed $value): array<string, mixed> {
    if (!$value instanceof KeyedTraversable) {
      throw TypeCoercionException::withValue('shape', $value);
    }

    $value = dict($value);
    $out = array();
    foreach ($this->inners as $key => $spec) {
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec->coerceType($value[$key] ?? null);
        continue;
      }

      try {
        $spec->coerceType(null);
      } catch (TypeCoercionException $e) {
        throw new TypeCoercionException(
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
    return $out;
  }

  public function assertType(mixed $value): array<string, mixed> {
    if (!is_array($value)) {
      throw IncorrectTypeException::withValue('shape', $value);
    }

    $value = dict($value);
    $out = array();
    foreach ($this->inners as $key => $spec) {
      if (C\contains_key($value, $key)) {
        $out[$key] = $spec->assertType($value[$key] ?? null);
        continue;
      }

      try {
        $spec->assertType(null);
      } catch (IncorrectTypeException $e) {
        throw new IncorrectTypeException(
          $e->getExpectedType(),
          'missing shape field',
        );
      }
    }
    foreach ($value as $k => $v) {
      if (!C\contains_key($out, $k)) {
        $out[$k] = $v;
      }
    }
    return $out;
  }
}
