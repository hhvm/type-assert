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

final class DictSpecTest extends TypeSpecTest<dict<arraykey, mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<dict<arraykey, int>> {
    return TypeSpec\dict(TypeSpec\arraykey(), TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, dict<arraykey, int>)> {
    return vec[
      tuple(Map {'foo' => 123}, dict['foo' => 123]),
      tuple(ImmMap {'foo' => 123}, dict['foo' => 123]),
      tuple(dict['foo' => 123], dict['foo' => 123]),
      tuple(dict[], dict[]),
      tuple(vec[123], dict[0 => 123]),
      tuple(vec['123'], dict[0 => 123]),
      tuple(keyset['123'], dict['123' => 123]),
      tuple(keyset[123], dict[123 => 123]),
      tuple(varray[123], dict[0 => 123]),
      tuple(darray["123" => 123], dict['123' => 123]),
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
  ): vec<(TypeSpec<dict<arraykey, mixed>>, string)> {
    return vec[
      tuple(
        TypeSpec\dict(TypeSpec\string(), TypeSpec\int()),
        dict::class.'<string, int>',
      ),
      tuple(
        TypeSpec\dict(TypeSpec\int(), TypeSpec\string()),
        dict::class.'<int, string>',
      ),
    ];
  }
}
