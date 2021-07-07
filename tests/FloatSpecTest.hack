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

final class FloatSpecTest extends TypeSpecTest<float> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<float> {
    return TypeSpec\float();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, float)> {
    return vec[
      tuple(123, 123.0),
      tuple(1.23, 1.23),
      tuple(0, 0.0),
      tuple('0', 0.0),
      tuple('123', 123.0),
      tuple('1.23', 1.23),
      tuple('.23', .23),
      tuple('1e2', 1e2),
      tuple('1.23e45', 1.23e45),
      tuple('1.23e-45', 1.23e-45),
      tuple('.12e34', .12e34),
      tuple(new TestStringable('1.23'), 1.23),
      tuple(Math\INT64_MAX, (float)Math\INT64_MAX),
      tuple((string)Math\INT64_MAX, (float)Math\INT64_MAX),
      tuple('9223372036854775808', 9223372036854775808.0), //INT64_MAX+1
      tuple('007', 7.0),
      tuple('-7', -7.0),
      tuple('-007', -7.0),
      tuple('-0.1', -0.1),
      tuple('-.5', -.5),
      tuple('-.9e2', -.9e2),
      tuple('-0.7e2', -0.7e2),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple('foo'),
      tuple(null),
      tuple(false),
      tuple(new \stdClass()),
      tuple(new TestStringable('foo')),
      tuple('0xFF'),
      tuple('1a'),
      tuple('e1'),
      tuple('1e'),
      tuple('ee7'),
      tuple('1e2e1'),
      tuple('1ee1'),
      tuple('1,2'), //Europeans use the comma instead of a full-stop
      tuple('+1'),
      tuple('3.'), //This is currently not allowed
    ];
  }

  <<__Override>>
  protected function equals(float $expected, mixed $value): bool {
    if (!($value is float)) {
      return false;
    }
    return \abs($expected - $value) < 0.00001;
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<float>, string)> {
    return vec[tuple(TypeSpec\float(), 'float')];
  }
}
