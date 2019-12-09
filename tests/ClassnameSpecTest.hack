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
  public function getValidCoercions(): vec<(mixed, classname<mixed>)> {
    return vec[tuple(self::class, self::class)];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(23),
      tuple(TypeSpecTest::class),
      tuple(-1),
      tuple('true'),
      tuple('false'),
    ];
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
