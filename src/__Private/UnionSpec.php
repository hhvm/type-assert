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

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException
};
use type Facebook\TypeSpec\TypeSpec;

abstract class UnionSpec<+T> extends TypeSpec<T> {
  private vec<TypeSpec<T>> $inners;
  public function __construct(
    private string $name,
    TypeSpec<T> ...$inners
  ) {
    $this->inners = vec($inners);
  }

  final public function coerceType(mixed $value): T {
    try {
      return $this->assertType($value);
    } catch (IncorrectTypeException $_) {
      // try coercion
    }
    foreach ($this->inners as $spec) {
      try {
        return $spec->coerceType($value);
      } catch (TypeCoercionException $_) {
        // try next
      }
    }
    throw TypeCoercionException::withValue($this->name, $value);
  }

  final public function assertType(mixed $value): T {
    foreach ($this->inners as $spec) {
      try {
        return $spec->assertType($value);
      } catch (IncorrectTypeException $_) {
        // try next
      }
    }
    throw IncorrectTypeException::withValue($this->name, $value);
  }
}
