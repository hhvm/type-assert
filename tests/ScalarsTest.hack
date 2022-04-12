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

use namespace Facebook\{TypeAssert, TypeCoerce};
use type Facebook\HackTest\DataProvider;
use function Facebook\FBExpect\expect;

final class ScalarsTest extends \Facebook\HackTest\HackTest {
  public function testIsStringPasses(): void {
    expect(TypeAssert\string('foo'))->toBeSame('foo');
  }

  public function testIsStringThrowsForInt(): void {
    expect(() ==> {
      TypeAssert\string(123);
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsIntPasses(): void {
    expect(TypeAssert\int(123))->toBeSame(123);
  }

  public function testIsIntThrowsForString(): void {
    expect(() ==> {
      TypeAssert\int('123');
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsIntThrowsForFloat(): void {
    expect(() ==> {
      TypeAssert\int(123.0);
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsFloatPasses(): void {
    expect(TypeAssert\float(1.23))->toBeSame(1.23);
  }

  public function testIsFloatThrowsForString(): void {
    expect(() ==> {
      TypeAssert\float('123');
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsFloatThrowsForInt(): void {
    expect(() ==> {
      TypeAssert\float(123);
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsResourcePasses(): void {
    expect(TypeAssert\resource(\STDERR))->toBeSame(\STDERR);
  }

  public function testIsResourceThrowsForObject(): void {
    expect(() ==> {
      TypeAssert\resource(new \stdClass());
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsNumPasses(): void {
    expect(TypeAssert\num(123))->toBeSame(123);
    expect(TypeAssert\num(1.23))->toBeSame(1.23);
  }

  public function testIsNumThrowsForString(): void {
    expect(() ==> {
      TypeAssert\num('123');
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsArrayKeyPasses(): void {
    expect(TypeAssert\arraykey(123))->toBeSame(123);
    expect(TypeAssert\arraykey('123'))->toBeSame('123');
  }

  public function testIsArrayKeyThrowsForFloat(): void {
    expect(() ==> {
      TypeAssert\arraykey(1.23);
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsNotNullPasses(): void {
    expect(TypeAssert\not_null(123))->toBeSame(123);
    expect(TypeAssert\not_null('foo bar'))->toBeSame('foo bar');
  }

  public function testIsNotNullThrows(): void {
    expect(() ==> {
      TypeAssert\not_null(null);
    })->toThrow(IncorrectTypeException::class);
  }

  public function testIsNotNullTypechecks(): void {
    return; // this test is just here for hh_client

    $wants_int = (int $_x) ==> {
    };
    $wants_int(TypeAssert\not_null(123));
    $wants_int(TypeAssert\not_null(null));

    $wants_string = (string $_x) ==> {
    };
    $wants_string(TypeAssert\not_null('foo bar'));
    $wants_string(TypeAssert\not_null(null));
  }

  public function getExampleValidCoercions(
  ): dict<string, ((function(mixed): mixed), mixed, mixed)> {
    return dict[
      'int to string' => tuple(TypeCoerce\string<>, 123, '123'),
      'intish string to int' => tuple(TypeCoerce\int<>, '123', 123),
      'intish string to num' => tuple(TypeCoerce\num<>, '123', 123),
      'decimal string to num' => tuple(TypeCoerce\num<>, '1.23', 1.23),
      'int to arraykey' => tuple(TypeCoerce\arraykey<>, 123, 123),
      'string to arraykey' => tuple(TypeCoerce\arraykey<>, '123', '123'),
      'stringable to arraykey' =>
        tuple(TypeCoerce\arraykey<>, new TestStringable('123'), '123'),
    ];
  }

  <<DataProvider('getExampleValidCoercions')>>
  public function testValidCoercion<Tin, Tout>(
    (function(Tin): Tout) $coercion,
    Tin $input,
    Tout $expected,
  ): void {
    expect($coercion($input))->toBeSame($expected);
  }
}
