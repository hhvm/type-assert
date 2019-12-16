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
use namespace HH\Lib\Keyset;

final class KeysetSpec<T as arraykey> extends TypeSpec<keyset<T>> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  <<__Override>>
  public function coerceType(mixed $value): keyset<T> {
    if (!$value is Traversable<_>) {
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

  <<__Override>>
  public function assertType(mixed $value): keyset<T> {
    if (!($value is keyset<_>)) {
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

  <<__Override>>
  public function toString(): string {
    return keyset::class.'<'.$this->inner->toString().'>';
  }
}
