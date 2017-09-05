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

final class NullableSpec<T> implements TypeSpec<?T> {
  public function __construct(
    private TypeSpec<T> $inner,
  ) {
  }

  public function coerceType(mixed $value): ?T {
    if ($value === null) {
      return null;
    }
    try {
      return $this->inner->coerceType($value);
    } catch (TypeCoercionException $e) {
      throw new TypeCoercionException(
        '?'.$e->getTargetType(),
        $e->getActualType(),
      );
    }
  }

  public function assertType(mixed $value): ?T {
    if ($value === null) {
      return null;
    }
    try {
      return $this->inner->assertType($value);
    } catch (IncorrectTypeException $e) {
      throw new IncorrectTypeException(
        '?'.$e->getExpectedType(),
        $e->getActualType(),
      );
    }
  }
}

function nullable<T>(TypeSpec<T> $inner): TypeSpec<?T> {
  return new NullableSpec($inner);
}
