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
use type Facebook\HackTest\HackTest;
use type Facebook\TypeSpec\TypeSpec;
use type Facebook\TypeAssert\TestFixtures\IntishStringEnum;
use function Facebook\FBExpect\expect;

final class CollectionSpecOdditiesTest extends HackTest {
  public function testContainerSpecsDisregardInnerSpecAndReturnTheIdenticalObject(
  ): void {
    $set = Set {1};
    expect(matches<\ConstSet<IntishStringEnum>>($set))->toEqual($set);

    $map = Map {1 => 1};
    expect(matches<\ConstMap<IntishStringEnum, int>>($map))->toEqual($map);
    expect(matches<\ConstMap<int, IntishStringEnum>>($map))->toEqual($map);

    $vector = Vector {1};
    expect(matches<\ConstVector<IntishStringEnum>>($vector))->toEqual($vector);
  }
}
