<?hh // strict
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

final class ClassnameSpec<Tinner, T as classname<Tinner>> extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(private T $what) {
  }

  public function assertType(mixed $value): T {
    if (is_string($value) && \is_a($value, $this->what, /* strings = */ true)) {
      /* HH_IGNORE_ERROR[4110] is_a is not understood by Hack */
      return $value;
    }
    throw
      IncorrectTypeException::withValue($this->getTrace(), $this->what, $value);
  }
}
