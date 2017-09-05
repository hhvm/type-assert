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

final class StringSpec implements TypeSpec<string> {
  public function coerceType(mixed $value): string {
    if (is_string($value)) {
      return $value;
    }
    if ($value instanceof \Stringish) {
      return (string) $value;
    }
    if (is_int($value)) {
      return (string) $value;
    }
    throw TypeCoercionException::withValue('string', $value);
  }

  public function assertType(mixed $value): string {
    if (is_string($value)) {
      return $value;
    }
    throw new IncorrectTypeException('string', gettype($value));
  }
}

function string(): TypeSpec<string> {
  return new StringSpec();
}
