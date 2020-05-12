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

final class NonNullSpecTest extends TypeSpecTest<nonnull> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<nonnull> {
    return TypeSpec\nonnull();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, nonnull)> {
    return vec[
      tuple(0, 0),
      tuple('', ''),
      tuple("\0", "\0"),
      tuple(\STDIN, \STDIN),
      tuple(false, false),
      tuple(vec[], vec[]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(null),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<nonnull>, string)> {
    return vec[
      tuple(TypeSpec\nonnull(), 'nonnull'),
    ];
  }
}
