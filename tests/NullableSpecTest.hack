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

final class NullableSpecTest extends TypeSpecTest<?int> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<?int> {
    return TypeSpec\nullable(TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, ?int)> {
    return vec[
      tuple(123, 123),
      tuple(null, null),
      tuple(0, 0),
      tuple('0', 0),
      tuple('123', 123),
      tuple(new TestStringable('123'), 123),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple('1.23'),
      tuple('1e123'),
      tuple(''),
      tuple(1.0),
      tuple(1.23),
      tuple(vec[]),
      tuple(vec[123]),
      tuple(false),
      tuple(true),
    ];
  }
}
