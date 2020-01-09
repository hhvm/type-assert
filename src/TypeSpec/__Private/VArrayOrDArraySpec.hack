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

use namespace Facebook\TypeSpec;

final class VArrayOrDArraySpec<T> extends UnionSpec<varray_or_darray<T>> {
  public function __construct(private TypeSpec\TypeSpec<T> $inner) {
    parent::__construct(
      'varray_or_darray',
      TypeSpec\darray(TypeSpec\arraykey(), $inner),
      TypeSpec\varray($inner),
    );
  }

  <<__Override>>
  public function toString(): string {
    return 'varray_or_darray<'.$this->inner->toString().'>';
  }
}
