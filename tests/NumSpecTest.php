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
    if (is_int($expected)) {
      return $expected === $value;
    }

    if (!is_float($value)) {
      return false;
    }
    
    return abs($expected - $value) < 0.00001;
  }
}
