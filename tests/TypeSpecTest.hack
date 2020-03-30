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

use namespace HH\Lib\{C, Vec};
use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use type Facebook\HackTest\DataProvider;
use function Facebook\FBExpect\expect;

abstract class TypeSpecTest<T> extends \Facebook\HackTest\HackTest {
  abstract public function getTypeSpec(): TypeSpec<T>;
  abstract public function getValidCoercions(): vec<(mixed, T)>;
  abstract public function getInvalidCoercions(): vec<(mixed)>;
  abstract public function getToStringExamples(): vec<(TypeSpec<T>, string)>;

  public function getValidValues(): vec<(T)> {
    $non_unique = $this->getValidCoercions()
      |> Vec\map(
        $$,
        ($tuple) ==> {
          list($_, $v) = $tuple;
          return tuple($v);
        },
      );

    $out = vec[];
    foreach ($non_unique as $v) {
      if (!C\contains($out, $v)) {
        $out[] = $v;
      }
    }
    return $out;
  }

  public function getInvalidValues(): vec<(mixed)> {
    $rows = $this->getInvalidCoercions();
    foreach ($this->getValidCoercions() as $arr) {
      list($value, $v) = $arr;
      if ($this->equals($v, $value)) {
        continue;
      }
      $rows[] = tuple($value);
    }
    return $rows;
  }

  /** Returns true if two values should be considered equal for coercion. */
  protected function equals(T $expected, mixed $actual): bool {
    return $expected === $actual;
  }

  protected function getNotEqualsMessage(T $expected, mixed $actual): string {
    return \sprintf(
      'Expected %s, got %s',
      \var_export($expected, true),
      \var_export($actual, true),
    );
  }

  <<DataProvider('getValidCoercions')>>
  final public function testValidCoercion(mixed $value, T $expected): void {
    $actual = $this->getTypeSpec()->coerceType($value);
    expect($this->equals($expected, $actual))
      ->toBeTrue($this->getNotEqualsMessage($expected, $actual));

    expect($this->getTypeSpec()->coerceType($actual))->toEqual(
      $actual,
      'Expected coerce(coerce(x)) to be the same value as coerce(x)',
    );
  }

  <<DataProvider('getInvalidCoercions')>>
  final public function testInvalidCoercion(mixed $value): void {
    expect(() ==> $this->getTypeSpec()->coerceType($value))->toThrow(
      TypeCoercionException::class,
    );
  }

  <<DataProvider('getValidValues')>>
  final public function testValidAssertion(T $value): void {
    $out = $this->getTypeSpec()->assertType($value);
    expect($out)->toEqual($value, $this->getNotEqualsMessage($value, $out));
  }

  <<DataProvider('getInvalidValues')>>
  final public function testInvalidAssertion(T $value): void {
    expect(() ==> $this->getTypeSpec()->assertType($value))->toThrow(
      IncorrectTypeException::class,
    );
  }

  <<DataProvider('getToStringExamples')>>
  final public function testToString(
    TypeSpec<mixed> $ts,
    string $expected,
  ): void {
    expect($ts->toString())->toBeSame($expected);
  }
}
