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

final class OptionalSpec<T> extends TypeSpec<T> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  public function isOptional(): bool {
    return true;
  }

  public function coerceType(mixed $value): T {
    return $this->inner->withTrace($this->getTrace())->coerceType($value);
  }

  public function assertType(mixed $value): T {
    return $this->inner->withTrace($this->getTrace())->assertType($value);
  }
}
