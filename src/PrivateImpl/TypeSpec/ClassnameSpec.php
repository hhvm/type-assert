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

final class ClassnameSpec<Tinner, T as classname<Tinner>>
  implements TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(private T $what) {
  }

  public function assertType(mixed $value): T {
    if (is_string($value) && is_a($value, $this->what, /* strings = */ true)) {
      /* HH_IGNORE_ERROR[4110] is_a is not understood by Hack */
      return $value;
    }
    throw IncorrectTypeException::withValue($this->what, $value);
  }
}

function classname<T>(classname<T> $what): TypeSpec<classname<T>> {
  return new ClassnameSpec($what);
}
