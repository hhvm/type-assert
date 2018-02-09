<?hh // strict
/*
 * Copyright (c) 2016, Fred Emmott
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

use namespace Facebook\{TypeAssert, TypeCoerce};
use function Facebook\FBExpect\expect;

final class ScalarsTest extends \PHPUnit\Framework\TestCase {
  public function testIsStringPasses(): void {
    $this->assertSame('foo', TypeAssert\string('foo'));
  }

  public function testIsStringThrowsForInt(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\string(123);
  }

  public function testIsIntPasses(): void {
    $this->assertSame(123, TypeAssert\int(123));
  }

  public function testIsIntThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\int('123');
  }

  public function testIsIntThrowsForFloat(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\int(123.0);
  }

  public function testIsFloatPasses(): void {
    $this->assertSame(1.23, TypeAssert\float(1.23));
  }

  public function testIsFloatThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\float('123');
  }

  public function testIsFloatThrowsForInt(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\float(123);
  }

  public function testIsResourcePasses(): void {
    $this->assertSame(\STDERR, TypeAssert\resource(\STDERR));
  }

  public function testIsResourceThrowsForObject(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\resource(new \stdClass());
  }

  public function testIsNumPasses(): void {
    $this->assertSame(123, TypeAssert\num(123));
    $this->assertSame(1.23, TypeAssert\num(1.23));
  }

  public function testIsNumThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\num('123');
  }

  public function testIsArrayKeyPasses(): void {
    $this->assertSame(123, TypeAssert\arraykey(123));
    $this->assertSame('123', TypeAssert\arraykey('123'));
  }

  public function testIsArrayKeyThrowsForFloat(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\arraykey(1.23);
  }

  public function testIsNotNullPasses(): void {
    $this->assertSame(123, TypeAssert\not_null(123));
    $this->assertSame('foo bar', TypeAssert\not_null('foo bar'));
  }

  public function testIsNotNullThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert\not_null(null);
  }

  public function testIsNotNullTypechecks(): void {
    return; // this test is just here for hh_client

    $wants_int = (int $x) ==> {
    };
    $wants_int(TypeAssert\not_null(123));
    $wants_int(TypeAssert\not_null(null));

    $wants_string = (string $x) ==> {
    };
    $wants_string(TypeAssert\not_null('foo bar'));
    $wants_string(TypeAssert\not_null(null));
  }

  public function getExampleValidCoercions(
  ): array<string, ((function(mixed):mixed), mixed, mixed)> {
    return [
      'int to string' => tuple(
        $x ==> TypeCoerce\string($x),
        123,
        '123',
      ),
      'intish string to int' => tuple(
        $x ==> TypeCoerce\int($x),
        '123',
        123,
      ),
      'intish string to num' => tuple(
        $x ==> TypeCoerce\num($x),
        '123',
        123
      ),
      'decimal string to num' => tuple(
        $x ==> TypeCoerce\num($x),
        '1.23',
        1.23
      ),
      'int to arraykey' => tuple(
        $x ==> TypeCoerce\arraykey($x),
        123,
        123,
      ),
      'string to arraykey' => tuple(
        $x ==> TypeCoerce\arraykey($x),
        '123',
        '123',
      ),
      'stringable to arraykey' => tuple(
        $x ==> TypeCoerce\arraykey($x),
        new TestStringable('123'),
        '123',
      ),
    ];
  }

  /**
   * @dataProvider getExampleValidCoercions
   */
  public function testValidCoercion<Tin, Tout>(
    (function(Tin): Tout) $coercion,
    Tin $input,
    Tout $expected,
  ): void {
    expect($coercion($input))->toBeSame($expected);
  }
}
