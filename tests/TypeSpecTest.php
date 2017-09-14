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

use type Facebook\TypeAssert\{
    IncorrectTypeException,
    TypeCoercionException
};
use type Facebook\TypeSpec\TypeSpec;
use function Facebook\FBExpect\expect;

abstract class TypeSpecTest<T> extends \PHPUnit\Framework\TestCase {
  abstract public function getTypeSpec(): TypeSpec<T>;
  abstract public function getValidCoercions(): array<(mixed, T)>;
  abstract public function getInvalidCoercions(): array<array<mixed>>;

  public function getValidValues(): array<array<T>> {
    return array_map(
      ($tuple) ==> { list($_, $v) = $tuple; return $v; },
      $this->getValidCoercions(),
    )
      |> array_unique($$)
      |> array_map($v ==> [$v], $$);
  }

  public function getInvalidValues(): array<array<mixed>> {
    $rows = $this->getInvalidCoercions();
    foreach ($this->getValidCoercions() as $arr) {
      list($value, $v) = $arr;
      if ($value === $v) {
        continue;
      }
      $rows[] = [$value];
    }
    return $rows;
  }

  protected function equals(T $expected, mixed $actual): bool {
    return $expected === $actual;
  }

  protected function getNotEqualsMessage(T $expected, mixed $actual): string {
    return sprintf(
      'Expected %s, got %s',
      var_export($expected, true),
      var_export($actual, true),
    );
  }

  /**
   * @dataProvider getValidCoercions
   */
  final public function testValidCoercion(mixed $value, T $expected): void {
    $actual = $this->getTypeSpec()->coerceType($value);
    expect($this->equals($expected, $actual))->toBeTrue(
      $this->getNotEqualsMessage($expected, $actual),
    );
  }

  /**
   * @dataProvider getInvalidCoercions
   */
  final public function testInvalidCoercion(mixed $value): void {
    expect(
      () ==> $this->getTypeSpec()->coerceType($value),
    )->toThrow(TypeCoercionException::class);
  }

  /**
   * @dataProvider getValidValues
   */
  final public function testValidAssertion(T $value): void {
    $out = $this->getTypeSpec()->assertType($value);
    expect($this->equals($out, $value))->toBeTrue(
      $this->getNotEqualsMessage($value, $out),
    );
  }

  /**
   * @dataProvider getInvalidValues
   */
  final public function testInvalidAssertion(T $value): void {
    expect(
      () ==> $this->getTypeSpec()->assertType($value),
    )->toThrow(IncorrectTypeException::class);
  }
}
