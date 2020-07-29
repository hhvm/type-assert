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

use namespace Facebook\{TypeAssert, TypeSpec};
use type Facebook\TypeAssert\TestFixtures\{ExampleEnum, TypeConstants};
use type Facebook\TypeSpec\TypeSpec;
use function Facebook\FBExpect\expect;

final class EnumSpecTest extends TypeSpecTest<ExampleEnum> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<ExampleEnum> {
    return TypeSpec\enum(ExampleEnum::class);
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, ExampleEnum)> {
    return vec[
      tuple('herp', ExampleEnum::HERP),
      tuple(ExampleEnum::DERP, ExampleEnum::DERP),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple('analbumcover'),
      tuple(42),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<ExampleEnum>, string)> {
    $spec = TypeSpec\enum(ExampleEnum::class);
    return vec[
      tuple($spec, ExampleEnum::class),
      tuple($spec, 'Facebook\\TypeAssert\\TestFixtures\\ExampleEnum'),
    ];
  }

  /**
   * In this test we mostly care that all these possible ways of coercing an
   * enum value are accepted by the typechecker. They should also not cause
   * runtime errors, but that's already covered by other tests.
   */
  public function testTypechecks(): void {
    self::takesEnum(TypeSpec\of<ExampleEnum>()->assertType('herp'));
    self::takesEnum(TypeSpec\enum(ExampleEnum::class)->assertType('herp'));
    self::takesEnum(TypeAssert\matches<ExampleEnum>('herp'));
    self::takesEnum(TypeAssert\matches_type_structure(
      type_structure(TypeConstants::class, 'TEnum'),
      'herp',
    ));
  }

  private static function takesEnum(ExampleEnum $value): void {
    expect($value is ExampleEnum)->toBeTrue();
  }
}
