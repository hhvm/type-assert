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

use namespace HH\Lib\Vec;

final class VecSpec<T> implements TypeSpec<vec<T>> {
  public function __construct(
    private TypeSpec<T> $inner,
  ) {
  }

  public function coerceType(mixed $value): vec<T> {
    if (!$value instanceof Traversable) {
      throw TypeCoercionException::withValue('vec<T>', $value);
    }

    return Vec\map(
      $value,
      $inner ==> $this->inner->coerceType($inner),
    );
  }

  public function assertType(mixed $value): vec<T> {
    if (!is_vec($value)) {
      throw IncorrectTypeException::withValue('vec<T>', $value);
    }

    return Vec\map(
      $value,
      $inner ==> $this->inner->assertType($inner),
    );
  }
}


function vec<Tv>(TypeSpec<Tv> $inner): TypeSpec<vec<Tv>> {
  return new VecSpec($inner);
}
