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

final class BoolSpec extends TypeSpec<bool> {
  <<__Override>>
  public function coerceType(mixed $value): bool {
    if ($value is bool) {
      return $value;
    }
    if ($value === 0) {
      return false;
    }
    if ($value === 1) {
      return true;
    }
    throw TypeCoercionException::withValue($this->getTrace(), 'bool', $value);
  }

  <<__Override>>
  public function assertType(mixed $value): bool {
    if ($value is bool) {
      return $value;
    }
    throw IncorrectTypeException::withValue($this->getTrace(), 'bool', $value);
  }

  <<__Override>>
  public function toString(): string {
    return 'bool';
  }
}
