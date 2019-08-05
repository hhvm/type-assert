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

use type Facebook\TypeAssert\IncorrectTypeException;
use type Facebook\TypeSpec\TypeSpec;

final class InstanceOfSpec<T> extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(private classname<T> $what) {
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    if (\is_a($value, $this->what)) {
      /* HH_IGNORE_ERROR[4110] unsafe for generics */
      return $value;
    }
    throw
      IncorrectTypeException::withValue($this->getTrace(), $this->what, $value);
  }

  <<__Override>>
  public function toString(): string {
    return $this->what;
  }
}
