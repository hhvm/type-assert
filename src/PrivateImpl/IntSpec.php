<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert\PrivateImpl;

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException,
  TypeSpec
};

final class IntSpec implements TypeSpec<int> {
  public function coerceType(mixed $value): int {
    if (is_int($value)) {
      return $value;
    }
    if ($value instanceof \Stringish) {
      $value = (string) $value;
      if ($value === '') {
        throw new TypeCoercionException(
          'int',
          'empty string',
        );
      }
      if (ctype_digit($value)) {
        return (int) $value;
      }
      throw new TypeCoercionException(
        'int',
        'string containing non-digit characters',
      );
    }
    throw TypeCoercionException::fromValue('int', $value);
  }

  public function assertType(mixed $value): int {
    if (is_int($value)) {
      return $value;
    }
    throw new IncorrectTypeException('int', gettype($value));
  }
}
