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

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Keyset;

final class KeysetSpec<T as arraykey> extends TypeSpec<keyset<T>> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  public function coerceType(mixed $value): keyset<T> {
    if (!$value instanceof Traversable) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'keyset<T>',
        $value,
      );
    }

    $trace = $this->getTrace()->withFrame('keyset<T>');

    return Keyset\map(
      $value,
      $inner ==> $this->inner->withTrace($trace)->coerceType($inner),
    );
  }

  public function assertType(mixed $value): keyset<T> {
    if (!is_keyset($value)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'keyset<T>',
        $value,
      );
    }

    $trace = $this->getTrace()->withFrame('keyset<T>');

    return Keyset\map(
      $value,
      $inner ==> $this->inner->withTrace($trace)->assertType($inner),
    );
  }
}
