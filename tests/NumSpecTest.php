<?hh // strict
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

final class NumSpecTest extends TypeSpecTest<num> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<num> {
    return TypeSpec\num();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, num)> {
    return [
      tuple(123, 123),
      tuple(1.23, 1.23),
      tuple(0, 0),
      tuple('0', 0),
      tuple('123', 123),
      tuple('1e23', 1e23),
      tuple('1.23', 1.23),
      tuple(new TestStringable('123'), 123),
      tuple(new TestStringable('1.23'), 1.23),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      [vec[]],
      [vec[123]],
      [null],
      [false],
      ['foo'],
    ];
  }

  <<__Override>>
  protected function equals(num $expected, mixed $value): bool {
    if ($expected is int) {
      return $expected === $value;
    }

    if (!($value is float)) {
      return false;
    }

    return \abs($expected - $value) < 0.00001;
  }
}
