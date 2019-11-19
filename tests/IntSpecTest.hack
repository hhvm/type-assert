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
use namespace HH\Lib\Math;

final class IntSpecTest extends TypeSpecTest<int> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<int> {
    return TypeSpec\int();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, int)> {
    return vec[
      tuple(123, 123),
      tuple(0, 0),
      tuple('0', 0),
      tuple('123', 123),
      tuple(new TestStringable('123'), 123),
      tuple((string)Math\INT64_MAX, Math\INT64_MAX),
      tuple('-321', -321),
      tuple((string)Math\INT64_MIN, Math\INT64_MIN),
      tuple(new TestStringable('-321'), -321),
      tuple('007', 7),
      tuple('000', 0),
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
      tuple(null),
      tuple(false),
      tuple(new TestStringable('1.23')),
      tuple('-007'),
      tuple(new TestStringable('-007')),
      tuple('9223372036854775808'), //Math\INT64_MAX+1
      tuple('-9223372036854775809'), //Math\INT64_MIN-1
      tuple('0xFF'),
    ];
  }
}
