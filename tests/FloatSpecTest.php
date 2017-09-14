<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

use namespace Facebook\TypeSpec;
use type Facebook\TypeSpec\TypeSpec;
use function Facebook\FBExpect\expect;

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
    ];
  }

  <<__Override>>
  protected function equals(float $expected, mixed $value): bool {
    if (!is_float($value)) {
      return false;
    }
    return abs($expected - $value) < 0.00001;
  }
}
