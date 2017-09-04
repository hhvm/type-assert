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

final class FloatSpec implements TypeSpec<float> {
  public function coerceType(mixed $value): float {
    if (is_float($value)) {
      return $value;
    }

    if (is_int($value)) {
      return (float) $value;
    }

    if ($value instanceof \Stringish) {
      $value = (string) $value;
      if ($value === '') {
        throw new TypeCoercionException(
          'float',
          'empty string',
        );
      }
      if (ctype_digit($value)) {
        return (float) $value;
      }
      if (
        preg_match(
          "/^(\\d*\\.)?\\d+([eE]\\d+)?$/",
          $value,
        ) === 1
      ) {
        return (float) $value;
      }
      throw new TypeCoercionException(
        'float',
        'non-float-like string',
      );
    }
    throw TypeCoercionException::fromValue('float', $value);
  }

  public function assertType(mixed $value): float {
    if (is_float($value)) {
      return $value;
    }
    throw new IncorrectTypeException('float', gettype($value));
  }
}
