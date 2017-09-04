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

use namespace Facebook\TypeAssert\TypeSpec;
use type Facebook\TypeAssert\TypeSpec;
use function Facebook\FBExpect\expect;

final class ResourceSpecTest extends TypeSpecTest<resource> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<resource> {
    return TypeSpec\resource();
  }

  <<__Override>>
  public function getValidCoercions(): array<(mixed, resource)> {
    $curl = curl_init();
    return [
      tuple(STDIN, STDIN),
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
