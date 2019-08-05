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
  public function getValidCoercions(): vec<(mixed, bool)> {
    return vec[
      tuple(false, false),
      tuple(true, true),
      tuple(0, false),
      tuple(1, true),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(null),
      tuple(23),
      tuple(-1),
      tuple('true'),
      tuple('false'),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<bool>, string)> {
    return vec[tuple(TypeSpec\bool(), 'bool')];
  }
}
