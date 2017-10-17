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

final class NullableSpec<T> extends TypeSpec<?T> {
  public function __construct(private TypeSpec<T> $inner) {
    invariant(
      !$inner instanceof OptionalSpec,
      'OptionalSpec should be the outermost spec',
    );
  }

  public function coerceType(mixed $value): ?T {
    if ($value === null) {
      return null;
    }
    try {
      return $this->inner->coerceType($value);
    } catch (TypeCoercionException $e) {
      throw new TypeCoercionException(
        $this->getTrace(),
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
        $e->getSpecTrace(),
        '?'.$e->getExpectedType(),
        $e->getActualType(),
      );
    }
  }
}
