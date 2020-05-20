/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeAssert;

use namespace Facebook\TypeSpec;
use type Facebook\TypeSpec\TypeSpec;

final class DArraySpecTest extends TypeSpecTest<darray<arraykey, mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<darray<arraykey, int>> {
    return TypeSpec\darray(TypeSpec\arraykey(), TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, darray<arraykey, int>)> {
    return vec[
      tuple(Map {'foo' => 123}, darray['foo' => 123]),
      tuple(ImmMap {'foo' => 123}, darray['foo' => 123]),
      tuple(dict['foo' => 123], darray['foo' => 123]),
      tuple(dict[], darray[]),
      tuple(vec[123], darray[0 => 123]),
      tuple(vec['123'], darray[0 => 123]),
      tuple(keyset['123'], darray['123' => 123]),
      tuple(keyset[123], darray[123 => 123]),
      tuple(varray[123], darray[0 => 123]),
      tuple(darray['123' => 123], darray['123' => 123]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(Map {'foo' => 'bar'}),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<darray<arraykey, mixed>>, string)> {
    return vec[
      tuple(
        TypeSpec\darray(TypeSpec\string(), TypeSpec\int()),
        'darray<string, int>',
      ),
      tuple(
        TypeSpec\darray(TypeSpec\int(), TypeSpec\string()),
        'darray<int, string>',
      ),
    ];
  }
}
