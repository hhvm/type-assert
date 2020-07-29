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

final class EnumSpec<T as arraykey> extends TypeSpec<T> {

  public function __construct(private \HH\enumname<T> $what) {
  }

  <<__Override>>
  public function coerceType(mixed $value): T {
    $what = $this->what;
    try {
      return $what::assert($value);
    } catch (\UnexpectedValueException $_e) {
      throw TypeCoercionException::withValue($this->getTrace(), $what, $value);
    }
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    $what = $this->what;
    try {
      return $what::assert($value);
    } catch (\UnexpectedValueException $_e) {
      throw IncorrectTypeException::withValue($this->getTrace(), $what, $value);
    }
  }

  <<__Override>>
  public function toString(): string {
    return $this->what;
  }
}
