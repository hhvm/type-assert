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

final class StringSpecTest extends TypeSpecTest<string> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<string> {
    return TypeSpec\string();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, string)> {
    return vec[
      tuple('foo', 'foo'),
      tuple(123, '123'),
      tuple(new TestStringable('herp derp'), 'herp derp'),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(1.23),
      tuple(vec['foo']),
      tuple(vec[]),
      tuple(vec[123]),
      tuple(null),
      tuple(false),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<string>, string)> {
    return vec[tuple(TypeSpec\string(), 'string')];
  }
}
