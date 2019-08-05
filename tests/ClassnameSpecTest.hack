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

final class ClassnameSpecTest extends TypeSpecTest<classname<mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<classname<mixed>> {
    return TypeSpec\classname(self::class);
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, classname<mixed>)> {
    return [tuple(self::class, self::class)];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [[23], [TypeSpecTest::class], [-1], ['true'], ['false']];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<classname<mixed>>, string)> {
    return vec[tuple(
      TypeSpec\classname(self::class),
      'classname<\\Facebook\\TypeAssert\\ClassnameSpecTest>',
    )];
  }
}
