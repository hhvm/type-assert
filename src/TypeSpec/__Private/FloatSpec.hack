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
use namespace HH\Lib\{Str, Regex};

final class FloatSpec extends TypeSpec<float> {

  <<__Override>>
  public function coerceType(mixed $value): float {
    if ($value is float) {
      return $value;
    }

    if ($value is int) {
      return (float)$value;
    }

    if ($value instanceof \Stringish) {
      /* HH_FIXME[4281] Stringish is going */
      $str = (string)$value;
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
      if (Regex\matches($str, re"/^-?(\\d*\\.)?\\d+([eE]\\d+)?$/")) {
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
}
