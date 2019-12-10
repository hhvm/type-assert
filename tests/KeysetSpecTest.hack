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

final class KeysetSpecTest extends TypeSpecTest<keyset<arraykey>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<keyset<int>> {
    return TypeSpec\keyset(TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, keyset<int>)> {
    return vec[
      tuple(vec[], keyset[]),
      tuple(Set {}, keyset[]),
      tuple(Set {123}, keyset[123]),
      tuple(Set {'123'}, keyset[123]),
      tuple(Vector {123}, keyset[123]),
      tuple(keyset[123], keyset[123]),
      tuple(dict['foobar' => '123'], keyset[123]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(ImmVector {'foo'}),
      tuple(ImmSet {'foo'}),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<keyset<arraykey>>, string)> {
    return vec[
      tuple(TypeSpec\keyset(TypeSpec\string()), 'keyset<string>'),
      tuple(TypeSpec\keyset(TypeSpec\int()), 'keyset<int>'),
    ];
  }
}
