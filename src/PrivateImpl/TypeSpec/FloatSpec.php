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

final class FloatSpec implements \Facebook\TypeSpec\TypeSpec<float> {
  public function coerceType(mixed $value): float {
    if (is_float($value)) {
      return $value;
    }

    if (is_int($value)) {
      return (float) $value;
    }

    if ($value instanceof \Stringish) {
      $str = (string) $value;
      if ($str === '') {
        throw TypeCoercionException::withValue('float', $value);
      }
      if (ctype_digit($value)) {
        return (float) $str;
      }
      if (
        preg_match(
          "/^(\\d*\\.)?\\d+([eE]\\d+)?$/",
          $str,
        ) === 1
      ) {
        return (float) $str;
      }
    }
    throw TypeCoercionException::withValue('float', $value);
  }

  public function assertType(mixed $value): float {
    if (is_float($value)) {
      return $value;
    }
    throw IncorrectTypeException::withValue('float', $value);
  }
}
