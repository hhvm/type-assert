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

final class VArraySpecTest extends TypeSpecTest<varray<mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<varray<int>> {
    return TypeSpec\of<vec<int>>();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, varray<int>)> {
    return vec[
      tuple(vec[], varray[]),
      tuple(vec['123'], varray[123]),
      tuple(varray['123'], varray[123]),
      tuple(varray[123], varray[123]),
      tuple(dict['foo' => '456'], varray[456]),
      tuple(Vector {123}, varray[123]),
      tuple(darray['foo' => 123], varray[123]),
      tuple(keyset['123'], varray[123]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(varray['foo']),
      tuple(vec['foo']),
      tuple(keyset['foo']),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<varray<mixed>>, string)> {
    return vec[
      tuple(TypeSpec\of<varray<string>>(), vec::class.'<string>'),
      tuple(TypeSpec\of<varray<int>>(), vec::class.'<int>'),
    ];
  }
}
