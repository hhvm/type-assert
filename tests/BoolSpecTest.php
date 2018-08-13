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

final class BoolSpecTest extends TypeSpecTest<bool> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<bool> {
    return TypeSpec\bool();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, bool)> {
    return [
      tuple(false, false),
      tuple(true, true),
      tuple(0, false),
      tuple(1, true),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      [null],
      [23],
      [-1],
      ['true'],
      ['false'],
    ];
  }
}
