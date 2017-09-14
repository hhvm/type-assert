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
use namespace HH\Lib\Vec;

final class VecSpec<T> extends TypeSpec<vec<T>> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  public function coerceType(mixed $value): vec<T> {
    if (!$value instanceof Traversable) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'vec<T>', $value);
    }

    $trace = $this->getTrace()->withFrame('vec<T>');
    return Vec\map(
      $value,
      $inner ==> $this->inner->withTrace($trace)->coerceType($inner),
    );
  }

  public function assertType(mixed $value): vec<T> {
    if (!is_vec($value)) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), 'vec<T>', $value);
    }

    $trace = $this->getTrace()->withFrame('vec<T>');
    return Vec\map(
      $value,
      $inner ==> $this->inner->withTrace($trace)->assertType($inner),
    );
  }
}
