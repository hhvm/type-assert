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

final class UntypedArraySpec extends TypeSpec<varray_or_darray<mixed>> {

  <<__Override>>
  public function coerceType(mixed $value): varray_or_darray<mixed> {
    if (!$value is KeyedTraversable<_, _>) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'array', $value);
    }

    $out = darray[];
    foreach ($value as $k => $v) {
      $out[$k as arraykey] = $v;
    }
    return $out;
  }

  <<__Override>>
  public function assertType(mixed $value): varray_or_darray<mixed> {
    if (!\HH\is_php_array($value)) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), 'array', $value);
    }

    if (varray($value) === $value) {
      return varray($value);
    }
    return darray($value);
  }

  <<__Override>>
  public function toString(): string {
    return 'varray_or_darray<mixed>';
  }
}
