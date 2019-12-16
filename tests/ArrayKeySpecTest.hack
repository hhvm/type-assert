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

final class ArrayKeySpecTest extends TypeSpecTest<arraykey> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<arraykey> {
    return TypeSpec\arraykey();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, arraykey)> {
    return vec[
      tuple(123, 123),
      tuple(0, 0),
      tuple('0', '0'),
      tuple('123', '123'),
      tuple('1e23', '1e23'),
      tuple(new TestStringable('123'), '123'),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(1.0),
      tuple(1.23),
      tuple(vec[]),
      tuple(vec[123]),
      tuple(null),
      tuple(false),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<arraykey>, string)> {
    return vec[tuple(TypeSpec\arraykey(), 'arraykey')];
  }
}
