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

final class ResourceSpecTest extends TypeSpecTest<resource> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<resource> {
    return TypeSpec\resource();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, resource)> {
    $curl = \curl_init();
    return [
      tuple(\STDIN, \STDIN),
      tuple($curl, $curl),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): array<array<mixed>> {
    return [
      [null],
      [23],
      ['/dev/stdin'],
      [false],
    ];
  }
}
