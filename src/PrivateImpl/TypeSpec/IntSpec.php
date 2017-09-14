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

final class IntSpec implements \Facebook\TypeSpec\TypeSpec<int> {
  public function coerceType(mixed $value): int {
    if (is_int($value)) {
      return $value;
    }
    if ($value instanceof \Stringish) {
      $str = (string) $value;
      if ($str !== '' && ctype_digit($str)) {
        return (int) $str;
      }
    }
    throw TypeCoercionException::withValue('int', $value);
  }

  public function assertType(mixed $value): int {
    if (is_int($value)) {
      return $value;
    }
    throw IncorrectTypeException::withValue('int', $value);
  }
}
