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

final class ConstMapSpecTest extends TypeSpecTest<\ConstMap<arraykey, mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<\ConstMap<arraykey, int>> {
    return TypeSpec\constmap(TypeSpec\arraykey(), TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, \ConstMap<arraykey, int>)> {
    return vec[
      tuple(Map {'foo' => 123}, Map {'foo' => 123}),
      tuple(ImmMap {'foo' => 123}, ImmMap {'foo' => 123}),
      tuple(dict['foo' => 123], ImmMap {'foo' => 123}),
      tuple(dict[], ImmMap {}),
      tuple(vec[123], ImmMap {0 => 123}),
      tuple(vec['123'], ImmMap {0 => 123}),
      tuple(keyset['123'], ImmMap {'123' => 123}),
      tuple(vec[123], ImmMap {0 => 123}),
      tuple(dict['123' => 123], ImmMap {'123' => 123}),
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
  ): vec<(TypeSpec<\ConstMap<arraykey, mixed>>, string)> {
    return vec[
      tuple(
        TypeSpec\constmap(TypeSpec\string(), TypeSpec\int()),
        \ConstMap::class.'<string, int>',
      ),
      tuple(
        TypeSpec\map(TypeSpec\int(), TypeSpec\string()),
        Map::class.'<int, string>',
      ),
      tuple(
        TypeSpec\immmap(TypeSpec\arraykey(), TypeSpec\string()),
        ImmMap::class.'<arraykey, string>',
      ),
    ];
  }

  <<__Override>>
  protected function equals(
    \ConstMap<arraykey, mixed> $expected,
    mixed $actual,
  ): bool {
    // ignore object identity
    return \serialize($expected) === \serialize($actual);
  }
}
