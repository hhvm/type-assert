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
    TypeCoercionException,
    TypeSpec
};
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

  /**
   * @dataProvider getValidCoercions
   */
  final public function testValidCoercion(mixed $value, T $expected): void {
    expect($this->getTypeSpec()->coerceType($value))->toBeSame($expected);
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
    expect($this->getTypeSpec()->assertType($value))->toBeSame($value);
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
