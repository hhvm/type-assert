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

final class InstanceOfSpec<T> implements TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(
    private classname<T> $what,
  ) {
  }

  public function assertType(mixed $value): T {
    if ($value instanceof $this->what) {
      /* HH_IGNORE_ERROR[4110] unsafe for generics */
      return $value;
    }
    throw IncorrectTypeException::withValue($this->what, $value);
  }
}

function instance_of<T>(classname<T> $what): TypeSpec<T> {
  return new InstanceOfSpec($what);
}
