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

final class ConstSetSpecTest extends TypeSpecTest<\ConstSet<arraykey>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<\ConstSet<int>> {
    return TypeSpec\constset(TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, \ConstSet<int>)> {
    return vec[
      tuple(vec[], ImmSet {}),
      tuple(Set {}, Set {}),
      tuple(Set {123}, Set {123}),
      tuple(Set {'123'}, ImmSet {123}),
      tuple(Vector {123}, ImmSet {123}),
      tuple(keyset[123], ImmSet {123}),
      tuple(dict['foobar' => '123'], ImmSet {123}),
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
  ): vec<(TypeSpec<\ConstSet<arraykey>>, string)> {
    return vec[
      tuple(TypeSpec\constset(TypeSpec\string()), \ConstSet::class.'<string>'),
      tuple(TypeSpec\set(TypeSpec\int()), Set::class.'<int>'),
      tuple(TypeSpec\immset(TypeSpec\arraykey()), ImmSet::class.'<arraykey>'),
    ];
  }

  <<__Override>>
  protected function equals(
    \ConstSet<arraykey> $expected,
    mixed $actual,
  ): bool {
    // ignore object identity
    return \serialize($expected) === \serialize($actual);
  }
}
