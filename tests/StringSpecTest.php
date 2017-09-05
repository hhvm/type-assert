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

use namespace Facebook\TypeAssert\PrivateImpl\TypeSpec;
use type Facebook\TypeAssert\PrivateImpl\TypeSpec\TypeSpec;
use function Facebook\FBExpect\expect;

final class StringSpecTest extends TypeSpecTest<string> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<string> {
    return TypeSpec\string();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, string)> {
    return [
      tuple('foo', 'foo'),
      tuple(123, '123'),
      tuple(new TestStringable('herp derp'), 'herp derp'),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      [1.23],
      [['foo']],
      [vec[]],
      [vec[123]],
      [null],
      [false],
    ];
  }
}
