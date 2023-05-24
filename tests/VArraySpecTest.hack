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

// This type is a misnomer (now).
// VArraySpecTest tests the behavior of `TypeSpec\of<varray<_>>()`,
// but the type under test is `VecSpec<_>`.
final class VArraySpecTest extends TypeSpecTest<vec<mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<vec<int>> {
    return TypeSpec\of<varray<int>>();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, vec<int>)> {
    return vec[
      tuple(vec[], vec[]),
      tuple(vec['123'], vec[123]),
      tuple(vec['123'], vec[123]),
      tuple(vec[123], vec[123]),
      tuple(dict['foo' => '456'], vec[456]),
      tuple(Vector {123}, vec[123]),
      tuple(dict['foo' => 123], vec[123]),
      tuple(keyset['123'], vec[123]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(vec['foo']),
      tuple(vec['foo']),
      tuple(keyset['foo']),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<vec<mixed>>, string)> {
    return vec[
      tuple(TypeSpec\of<varray<string>>(), vec::class.'<string>'),
      tuple(TypeSpec\of<varray<int>>(), vec::class.'<int>'),
    ];
  }
}
