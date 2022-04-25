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

use type Facebook\HackTest\HackTest;
use type Facebook\TypeAssert\TestFixtures\IntishStringEnum;
use function Facebook\FBExpect\expect;

final class CollectionSpecOdditiesTest extends HackTest {
  public function testContainerSpecsHonorInnerSpecAndReturnANewObject(): void {
    $set = Set {1};
    $copy_set = new Set($set);
    expect(matches<\ConstSet<IntishStringEnum>>($set))->toHaveSameContentAs(
      ImmSet {IntishStringEnum::ONE},
    );
    expect($set)->toHaveSameContentAs($copy_set, 'to be unchanged');

    $map = Map {1 => 1};
    $copy_map = new Map($map);
    expect(matches<\ConstMap<IntishStringEnum, int>>($map))
      ->toHaveSameContentAs(ImmMap {IntishStringEnum::ONE => 1});
    expect(matches<\ConstMap<int, IntishStringEnum>>($map))
      ->toHaveSameContentAs(ImmMap {1 => IntishStringEnum::ONE});
    expect($map)->toHaveSameShapeAs($copy_map, 'to be unchanged');

    $vector = Vector {1};
    $copy_vector = new Vector($vector);
    expect(matches<\ConstVector<IntishStringEnum>>($vector))
      ->toHaveSameContentAs(ImmVector {IntishStringEnum::ONE});
    expect($vector)->toHaveSameContentAs($copy_vector, 'to be unchanged');
  }

  public function testWhenNoChangesConstXXXDoesNotPromoteToImm(): void {
    $set = Set {1};
    expect(matches<\ConstSet<int>>($set))->toEqual($set);

    $map = Map {1 => 1};
    expect(matches<\ConstMap<int, int>>($map))->toEqual($map);

    $vector = Vector {1};
    expect(matches<\ConstVector<int>>($vector))->toEqual($vector);
  }

  public function testWhenChangeesConstXXXDoesPromoteToImm(): void {
    $set = Set {1};
    expect(matches<\ConstSet<IntishStringEnum>>($set))->toBeInstanceOf(
      ImmSet::class,
    );

    $map = Map {1 => 1};
    expect(matches<\ConstMap<IntishStringEnum, int>>($map))->toBeInstanceOf(
      ImmMap::class,
    );
    expect(matches<\ConstMap<int, IntishStringEnum>>($map))->toBeInstanceOf(
      ImmMap::class,
    );

    $vector = Vector {1};
    expect(matches<\ConstVector<IntishStringEnum>>($vector))->toBeInstanceOf(
      ImmVector::class,
    );
  }
}
