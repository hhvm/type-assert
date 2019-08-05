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
  public function getTypeSpec(): TypeSpec<\ConstMap<arraykey, mixed>> {
    return TypeSpec\constmap(TypeSpec\string(), TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(
  ): array<(mixed, \ConstMap<arraykey, mixed>)> {
    return [
      tuple(Map {'foo' => 123}, Map {'foo' => 123}),
      tuple(dict['foo' => 123], ImmMap {'foo' => 123}),
      tuple(Map {}, Map {}),
      tuple(dict[], ImmMap {}),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      [false],
      [Map {123 => 'foo'}],
      [Vector {123}],
      [keyset[123]],
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<\ConstMap<arraykey, mixed>>, string)> {
    return vec[tuple(
      TypeSpec\constmap(TypeSpec\string(), TypeSpec\int()),
      '\\ConstMap<string, int>'
    )];
  }
}
