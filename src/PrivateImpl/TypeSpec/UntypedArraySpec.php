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
use type Facebook\TypeSpec\TypeSpec;

/* HH_IGNORE_ERROR[4045] array without generics */
final class UntypedArraySpec implements TypeSpec<array> {

  /* HH_IGNORE_ERROR[4045] array without generics */
  public function coerceType(mixed $value): array {
    if (!$value instanceof KeyedTraversable) {
      throw TypeCoercionException::withValue('array', $value);
    }

    $out = [];
    foreach ($value as $k => $v) {
      $out[$k] = $v;
    }
    return $out;
  }

  /* HH_IGNORE_ERROR[4045] array without generics */
  public function assertType(mixed $value): array {
    if (!is_array($value)) {
      throw IncorrectTypeException::withValue('array', $value);
    }

    $out = [];
    foreach ($value as $k => $v) {
      $out[$k] = $v;
    }
    return $out;
  }
}
