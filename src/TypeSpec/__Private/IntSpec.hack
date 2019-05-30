/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Str;

final class IntSpec extends TypeSpec<int> {
  <<__Override>>
  public function coerceType(mixed $value): int {
    if ($value is int) {
      return $value;
    }
    if ($value instanceof \Stringish) {
      /* HH_FIXME[4281] Stringish is going */
      $str = (string)$value;
      $int = (int)$str;
      if ($str === (string)$int) {
        return $int;
      }
      $str = Str\trim_left($str, '0');
      if ($str === (string)$int) {
        return $int;
      }
    }
    throw TypeCoercionException::withValue($this->getTrace(), 'int', $value);
  }

  <<__Override>>
  public function assertType(mixed $value): int {
    if ($value is int) {
      return $value;
    }
    throw IncorrectTypeException::withValue($this->getTrace(), 'int', $value);
  }
}
