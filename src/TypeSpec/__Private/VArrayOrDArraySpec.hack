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

use namespace HH\Lib\{C, Vec};
use namespace Facebook\TypeSpec;

final class VArrayOrDArraySpec<T> extends UnionSpec<varray_or_darray<T>> {
  private TypeSpec\TypeSpec<darray<arraykey, T>> $darraySpec;
  private TypeSpec\TypeSpec<varray<T>> $varraySpec;

  public function __construct(private TypeSpec\TypeSpec<T> $inner) {
    $this->darraySpec = TypeSpec\darray(TypeSpec\arraykey(), $inner);
    $this->varraySpec = TypeSpec\varray($inner);
    parent::__construct(
      'varray_or_darray',
      $this->darraySpec,
      $this->varraySpec,
    );
  }

  <<__Override>>
  public function toString(): string {
    return 'varray_or_darray<'.$this->inner->toString().'>';
  }

  <<__Override>>
  public function coerceType(mixed $value): varray_or_darray<T> {
    try {
      return $this->assertType($value);
    } catch (\Throwable $_) {
    }

    if ($value is vec<_> || $value is /* HH_FIXME[2049] */ ConstVector<_>) {
      return $this->varraySpec->coerceType($value);
    }

    if ($value is dict<_, _> || $value is /* HH_FIXME[2049] */ ConstMap<_, _>) {
      return $this->darraySpec->coerceType($value);
    }

    $new = $this->darraySpec->coerceType($value);
    if ($new === darray[]) {
      return $new;
    }

    if (Vec\keys($new) === Vec\range(0, C\count($new) - 1)) {
      return varray($new);
    }
    return $new;
  }
}
