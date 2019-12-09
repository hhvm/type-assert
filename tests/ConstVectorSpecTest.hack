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

final class ConstVectorSpecTest extends TypeSpecTest<\ConstVector<mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<\ConstVector<int>> {
    return TypeSpec\constvector(TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, \ConstVector<int>)> {
    return vec[
      tuple(vec[], ImmVector {}),
      tuple(vec['123'], ImmVector {123}),
      tuple(varray['123'], ImmVector {123}),
      tuple(darray[123 => '123'], ImmVector {123}),
      tuple(ImmVector {'123'}, ImmVector {123}),
      tuple(Vector {'123'}, ImmVector {123}),
      tuple(Vector {123}, Vector {123}),
      tuple(Vector {}, Vector {}),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(ImmVector {'foo'}),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<\ConstVector<mixed>>, string)> {
    return vec[
      tuple(
        TypeSpec\constvector(TypeSpec\string()),
        \ConstVector::class.'<string>',
      ),
      tuple(TypeSpec\vector(TypeSpec\int()), Vector::class.'<int>'),
      tuple(TypeSpec\immvector(TypeSpec\mixed()), ImmVector::class.'<mixed>'),
    ];
  }

  <<__Override>>
  protected function equals(
    \ConstVector<mixed> $expected,
    mixed $actual,
  ): bool {
    // ignore object identity
    return \serialize($expected) === \serialize($actual);
  }
}
