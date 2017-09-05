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

final class BoolSpec implements TypeSpec<bool> {
  public function coerceType(mixed $value): bool {
    if (is_bool($value)) {
      return $value;
    }
    if ($value === 0) {
      return false;
    }
    if ($value === 1) {
      return true;
    }
    throw TypeCoercionException::withValue('bool', $value);
  }

  public function assertType(mixed $value): bool {
    if (is_bool($value)) {
      return $value;
    }
    throw IncorrectTypeException::withValue('bool', $value);
  }
}

function bool(): TypeSpec<bool> {
  return new BoolSpec();
}
