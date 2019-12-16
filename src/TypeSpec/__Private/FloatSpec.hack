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
use namespace HH\Lib\Regex;

final class FloatSpec extends TypeSpec<float> {

  <<__Override>>
  public function coerceType(mixed $value): float {
    if ($value is float) {
      return $value;
    }

    if ($value is int) {
      return (float)$value;
    }

    if ($value is \Stringish) {
      $str = stringish_cast($value, __CLASS__.'::'.__METHOD__);
      if ($str === '') {
        throw TypeCoercionException::withValue(
          $this->getTrace(),
          'float',
          $value,
        );
      }

      //I presume this is here because it is cheaper than the regex.
      //Removing this call does not affect the output of tests.
      if (\ctype_digit($value)) {
        return (float)$str;
      }
      /*REGEX
        At the beginning of a string, find an optional minus. ^-?
        Find at least one digit
        with an optional period between them or preceeding them. (?:\d*\.)?\d+
        Optionally: Find and e or E followed at least one digit. (?:[eE]\d+)?
        The end of the string. $
      */
      if (Regex\matches($str, re"/^-?(?:\\d*\\.)?\\d+(?:[eE]\\d+)?$/")) {
        return (float)$str;
      }
    }
    throw TypeCoercionException::withValue($this->getTrace(), 'float', $value);
  }

  <<__Override>>
  public function assertType(mixed $value): float {
    if ($value is float) {
      return $value;
    }
    throw IncorrectTypeException::withValue($this->getTrace(), 'float', $value);
  }

  <<__Override>>
  public function toString(): string {
    return 'float';
  }
}
