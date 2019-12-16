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

final class ResourceSpecTest extends TypeSpecTest<resource> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<resource> {
    return TypeSpec\resource();
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, resource)> {
    $curl = \curl_init();
    return vec[
      tuple(\STDIN, \STDIN),
      tuple($curl, $curl),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(null),
      tuple(23),
      tuple('/dev/stdin'),
      tuple(false),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<resource>, string)> {
    return vec[
      tuple(TypeSpec\resource(), 'resource'),
      tuple(TypeSpec\resource('curl'), 'resource'),
    ];
  }
}
