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

final class ScalarsTest extends \PHPUnit\Framework\TestCase {
  public function testIsStringPasses(): void {
    $this->assertSame('foo', namespace\string('foo'));
  }

  public function testIsStringThrowsForInt(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\string(123);
  }

  public function testIsIntPasses(): void {
    $this->assertSame(123, namespace\int(123));
  }

  public function testIsIntThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\int('123');
  }

  public function testIsIntThrowsForFloat(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\int(123.0);
  }

  public function testIsFloatPasses(): void {
    $this->assertSame(1.23, namespace\float(1.23));
  }

  public function testIsFloatThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\float('123');
  }

  public function testIsFloatThrowsForInt(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\float(123);
  }

  public function testIsResourcePasses(): void {
    $this->assertSame(STDERR, namespace\resource(STDERR));
  }

  public function testIsResourceThrowsForObject(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\resource(new \stdClass());
  }

  public function testIsNumPasses(): void {
    $this->assertSame(123, namespace\num(123));
    $this->assertSame(1.23, namespace\num(1.23));
  }

  public function testIsNumThrowsForString(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\num('123');
  }

  public function testIsArrayKeyPasses(): void {
    $this->assertSame(123, namespace\arraykey(123));
    $this->assertSame('123', namespace\arraykey('123'));
  }

  public function testIsArrayKeyThrowsForFloat(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\arraykey(1.23);
  }

  public function testIsNotNullPasses(): void {
    $this->assertSame(123, namespace\not_null(123));
    $this->assertSame('foo bar', namespace\not_null('foo bar'));
  }

  public function testIsNotNullThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\not_null(null);
  }

  public function testIsNotNullTypechecks(): void {
    return; // this test is just here for hh_client

    $wants_int = (int $x) ==> {
    };
    $wants_int(namespace\not_null(123));
    $wants_int(namespace\not_null(null));

    $wants_string = (string $x) ==> {
    };
    $wants_string(namespace\not_null('foo bar'));
    $wants_string(namespace\not_null(null));
  }
}
