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

/* HH_IGNORE_ERROR[2071] varray_or_darray without generics */
final class UntypedArraySpec extends TypeSpec<varray_or_darray> {

  <<__Override>>
  /* HH_IGNORE_ERROR[2071] varray_or_darray without generics */
  public function coerceType(mixed $value): varray_or_darray {
    if (!$value is KeyedTraversable<_, _>) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'array', $value);
    }

    /*HH_IGNORE_ERROR[2083]
      we are intentionally making a varray_or_darray,
      so we need the PHP syntax*/
    $out = [];
    foreach ($value as $k => $v) {
      $out[$k as arraykey] = $v;
    }
    return $out;
  }

  <<__Override>>
  /* HH_IGNORE_ERROR[2071] varray_or_darray without generics */
  public function assertType(mixed $value): varray_or_darray {
    if (!\is_array($value)) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), 'array', $value);
    }

    /*HH_IGNORE_ERROR[2083]
      we are intentionally making a varray_or_darray,
      so we need the PHP syntax*/
    $out = [];
    foreach ($value as $k => $v) {
      $out[$k] = $v;
    }
    return $out;
  }
}
