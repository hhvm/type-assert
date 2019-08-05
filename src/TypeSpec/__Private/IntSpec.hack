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
    if ($value is \Stringish) {
      $str = stringish_cast($value, __CLASS__.'::'.__METHOD__);
      $int = (int)$str;

      // "1234"   -(int)->   1234   -(string)->   "1234"
      // "-1234"  -(int)->   -1234  -(string)->   "-1234"
      //   ^^           are the same                ^^
      if ($str === (string)$int) {
        return $int;
      }

      // "0001234" -(trim)-> "1234" -(int)-> 1234 -(string)-> "1234"
      //                       ^^        are the same           ^^
      $str = Str\trim_left($str, '0');
      if ($str === (string)$int) {
        return $int;
      }

      // Exceptional case "000" -(trim)-> "", but we want to return 0
      if ($str === '' && $value !== '') {
        return 0;
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

  <<__Override>>
  public function toString(): string {
    return 'int';
  }
}
