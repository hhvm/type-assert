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
  public function getValidCoercions(): array<(mixed, float)> {
    return [
      tuple(123, 123.0),
      tuple(1.23, 1.23),
      tuple(0, 0.0),
      tuple('0', 0.0),
      tuple('123', 123.0),
      tuple('1.23', 1.23),
      tuple('.23', .23),
      tuple('1e2', 1e2),
      tuple('1.23e45', 1.23e45),
      tuple('.12e34', .12e34),
      tuple(new TestStringable('1.23'), 1.23),
      tuple(Math\INT64_MAX, (float)Math\INT64_MAX),
      tuple((string)Math\INT64_MAX, (float)Math\INT64_MAX),
      tuple("9223372036854775808", 9223372036854775808.0), //INT64_MAX+1
      tuple('007', 7.0),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      ['foo'],
      [null],
      [false],
      [new \stdClass()],
      [new TestStringable('foo')],
      ['0xFF'],
      ['1a'],
      ['e1'],
      ['1e'],
      ['1e2e1'],
      ['1ee1'],
      ['1,2'], //Europeans use the comma instead of a full-stop
    ];
  }

  <<__Override>>
  protected function equals(float $expected, mixed $value): bool {
    if (!($value is float)) {
      return false;
    }
    return \abs($expected - $value) < 0.00001;
  }
}
