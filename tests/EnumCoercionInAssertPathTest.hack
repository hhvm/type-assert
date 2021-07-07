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

use namespace Facebook\TypeAssert;
use type Facebook\TypeAssert\TestFixtures\IntegralKeyCoercionEnum;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class EnumCoercionInAssertPathTest extends HackTest {
  public function test_coercion_does_warn(): void {
    expect(() ==> TypeAssert\matches<IntegralKeyCoercionEnum>('3'))
      ->toTriggerAnError(\E_USER_DEPRECATED, 'does contain the int value 3');
    expect(() ==> TypeAssert\matches<IntegralKeyCoercionEnum>(2))
      ->toTriggerAnError(\E_USER_DEPRECATED, 'does contain the string value 2');
  }

  public function test_coersion_does_not_warn_if_both_int_and_string_exist(
  ): void {
    try {
      \set_error_handler(() ==> {
        throw new \LogicException('No error expected');
      });
      TypeAssert\matches<IntegralKeyCoercionEnum>(1);
    } finally {
      \set_error_handler(null);
    }
  }
}
