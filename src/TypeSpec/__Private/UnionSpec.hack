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

abstract class UnionSpec<+T> extends TypeSpec<T> {
  private vec<TypeSpec<T>> $inners;
  public function __construct(private string $name, TypeSpec<T> ...$inners) {
    $this->inners = vec($inners);
  }

  <<__Override>>
  public function coerceType(mixed $value): T {
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
    throw TypeCoercionException::withValue(
      $this->getTrace(),
      $this->name,
      $value,
    );
  }

  <<__Override>>
  final public function assertType(mixed $value): T {
    foreach ($this->inners as $spec) {
      try {
        return $spec->assertType($value);
      } catch (IncorrectTypeException $_) {
        // try next
      }
    }
    throw IncorrectTypeException::withValue(
      $this->getTrace(),
      $this->name,
      $value,
    );
  }

  <<__Override>>
  public function toString(): string {
    return $this->name;
  }
}
