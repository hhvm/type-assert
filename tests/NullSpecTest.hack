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

final class NullSpecTest extends TypeSpecTest<null> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<null> {
    return TypeSpec\null();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, null)> {
    return vec[
      tuple(null, null),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(0),
      tuple(''),
      tuple("\0"),
      tuple(\STDIN),
      tuple(false),
      tuple(vec[]),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<null>, string)> {
    return vec[
      tuple(TypeSpec\null(), 'null'),
    ];
  }
}
