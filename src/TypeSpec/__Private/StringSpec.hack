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

final class StringSpec extends TypeSpec<string> {
  <<__Override>>
  public function coerceType(mixed $value): string {
    if ($value is string) {
      return $value;
    }
    if ($value is \Stringish) {
      return stringish_cast($value, __CLASS__.'::'.__METHOD__);
    }
    if ($value is int) {
      return (string)$value;
    }
    throw TypeCoercionException::withValue($this->getTrace(), 'string', $value);
  }

  <<__Override>>
  public function assertType(mixed $value): string {
    if ($value is string) {
      return $value;
    }
    throw new IncorrectTypeException(
      $this->getTrace(),
      'string',
      \gettype($value),
    );
  }

  <<__Override>>
  public function toString(): string {
    return 'string';
  }
}
