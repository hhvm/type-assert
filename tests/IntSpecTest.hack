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

final class IntSpecTest extends TypeSpecTest<int> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<int> {
    return TypeSpec\int();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, int)> {
    return [
      tuple(123, 123),
      tuple(0, 0),
      tuple('0', 0),
      tuple('123', 123),
      tuple(new TestStringable('123'), 123),
      tuple('-321', -321),
      tuple(new TestStringable('-321'), -321),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      ['1.23'],
      ['1e123'],
      [''],
      [1.0],
      [1.23],
      [[123]],
      [vec[]],
      [vec[123]],
      [null],
      [false],
      [new TestStringable('1.23')],
      ['007'],
      ['-007'],
      [new TestStringable('-007')],
      ['9223372036854775808'],
    ];
  }
}
