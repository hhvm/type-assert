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

use \Facebook\TypeAssert\TestFixtures\ExampleEnum;
use \Facebook\TypeAssert\TestFixtures\TypeConstants as C;

use namespace Facebook\{TypeAssert, TypeCoerce};
use namespace HH\Lib\Dict;

use function Facebook\FBExpect\expect;

final class TypeStructureTest extends \PHPUnit\Framework\TestCase {
  public function getExampleValidTypes(): array<string, (mixed, mixed)> {
    return [
      'int' => tuple(type_structure(C::class, 'TInt'), 123),
      'bool' => tuple(type_structure(C::class, 'TBool'), true),
      'float' => tuple(type_structure(C::class, 'TFloat'), 1.23),
      'string' => tuple(type_structure(C::class, 'TString'), 'foo'),
      'int-as-num' => tuple(type_structure(C::class, 'TNum'), 123),
      'float-as-num' => tuple(type_structure(C::class, 'TNum'), 1.23),
      'string-as-arraykey' =>
        tuple(type_structure(C::class, 'TArrayKey'), 'foo'),
      'int-as-arraykey' => tuple(type_structure(C::class, 'TArrayKey'), 123),
      'tuple' => tuple(type_structure(C::class, 'TTuple'), tuple('foo', 123)),
      'empty array<string>' =>
        tuple(type_structure(C::class, 'TStringArray'), []),
      'array<string>' =>
        tuple(type_structure(C::class, 'TStringArray'), ['123', '456']),
      'empty array<string, string>' =>
        tuple(type_structure(C::class, 'TStringStringArray'), []),
      'array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        ['foo' => 'bar', 'herp' => 'derp'],
      ),
      'string as ?string' =>
        tuple(type_structure(C::class, 'TNullableString'), 'hello, world'),
      'null as ?string' =>
        tuple(type_structure(C::class, 'TNullableString'), null),
      'stdClass' =>
        tuple(type_structure(C::class, 'TStdClass'), new \stdClass()),
      'empty Vector<string>' =>
        tuple(type_structure(C::class, 'TStringVector'), Vector {}),
      'Vector<string>' => tuple(
        type_structure(C::class, 'TStringVector'),
        Vector { 'foo', 'bar' },
      ),
      'empty Map<string, string>' =>
        tuple(type_structure(C::class, 'TStringStringMap'), Map {}),
      'Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 'derp' },
      ),
      'Vector<Vector<string>>' => tuple(
        type_structure(C::class, 'TStringVectorVector'),
        Vector { Vector { 'foo' } },
      ),
      'Vector<Vector<string>> with no outer elems' =>
        tuple(type_structure(C::class, 'TStringVectorVector'), Vector {}),
      'Vector<Vector<string>> with no inner elems' => tuple(
        type_structure(C::class, 'TStringVectorVector'),
        Vector { Vector {} },
      ),
      'shape with missing ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 'foo'),
      ),
      'shape with null ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 'foo', 'someNullable' => null),
      ),
      'shape with string ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 'foo', 'someNullable' => 'string'),
      ),
      'shape with extra field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 'foo', 'some junk' => 'bar'),
      ),
      'nested shape' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape('someString' => 'bar'),
        ),
      ),
      'shape with empty container' => tuple(
        type_structure(C::class, 'TShapeWithContainer'),
        array('container' => Vector {}),
      ),
      'shape with non-empty container' => tuple(
        type_structure(C::class, 'TShapeWithContainer'),
        array('container' => Vector { 'foo' }),
      ),
      'enum' => tuple(type_structure(C::class, 'TEnum'), ExampleEnum::DERP),
      'vec<int>' => tuple(
        type_structure(C::class, 'TIntVec'),
        vec[1, 2, 3],
      ),
      'vec<vec<string>>' => tuple(
        type_structure(C::class, 'TIntVecVec'),
        vec[vec[1, 2, 3], vec[4, 5, 6]],
      ),
      'dict<string, string>' => tuple(
        type_structure(C::class, 'TStringStringDict'),
        dict[
          'foo' => 'bar',
          'herp' => 'derp',
        ],
      ),
      'dict<string, vec<string>>' => tuple(
        type_structure(C::class, 'TStringStringVecDict'),
        dict[
          'foo' => vec['bar', 'baz'],
          'herp' => vec['derp'],
        ],
      ),
      'keyset<string>' => tuple(
        type_structure(C::class, 'TStringKeyset'),
        keyset['foo', 'bar', 'baz', 'herp', 'derp'],
      ),
      'empty array as array<>' => tuple(
        type_structure(C::class, 'TArrayWithoutGenerics'),
        [],
      ),
      'vec-like array as array<>' => tuple(
        type_structure(C::class, 'TArrayWithoutGenerics'),
        ['foo', 'bar'],
      ),
      'dict-like array as array<>' => tuple(
        type_structure(C::class, 'TArrayWithoutGenerics'),
        ['foo' => 'bar'],
      ),
      'empty array in array<> shape field' => tuple(
        type_structure(C::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => []),
      ),
      'vec-like array in array<> shape field' => tuple(
        type_structure(C::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => ['foo', 'bar']),
      ),
      'dict-like array in array<> shape field' => tuple(
        type_structure(C::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => ['foo' => 'bar']),
      ),
    ];
  }

  /**
   * @dataProvider getExampleValidTypes
   */
  public function testValidType<T>(TypeStructure<T> $ts, T $input): void {
    expect(TypeAssert\matches_type_structure($ts, $input))
      ->toBeSame($input);
  }

  public function getExampleInvalidTypes(): array<string, (mixed, mixed)> {
    return [
      '"123" as int' => tuple(type_structure(C::class, 'TInt'), '123'),
      '1 as bool' => tuple(type_structure(C::class, 'TBool'), 1),
      'int as float' => tuple(type_structure(C::class, 'TFloat'), 123),
      'int as string' => tuple(type_structure(C::class, 'TString'), 123),
      'string as num' => tuple(type_structure(C::class, 'TNum'), '123'),
      'float as arraykey' => tuple(type_structure(C::class, 'TArrayKey'), 1.23),
      'incorrect tuple field types' =>
        tuple(type_structure(C::class, 'TTuple'), tuple('foo', '123')),
      'too many tuple fields' =>
        tuple(type_structure(C::class, 'TTuple'), tuple('foo', 123, 456)),
      'int in array<string>' =>
        tuple(type_structure(C::class, 'TStringArray'), [123]),
      'int keys in array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        [123 => 'bar', 123 => 'derp'],
      ),
      'int values in array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        ['foo' => 123, 'bar' => 456],
      ),
      '0 as ?string' => tuple(type_structure(C::class, 'TNullableString'), 0),
      'wrong object type' =>
        tuple(type_structure(C::class, 'TStdClass'), ImmMap {}),
      'ints in Vector<string>' =>
        tuple(type_structure(C::class, 'TStringVector'), Vector { 'foo', 123 }),
      'int keys in Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 123 => 'foo' },
      ),
      'int values in Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 123 },
      ),
      'shape with missing field' =>
        tuple(type_structure(C::class, 'TFlatShape'), shape()),
      'shape with incorrect field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 123),
      ),
      'Vector<Vector<string>> with non-container child' => tuple(
        type_structure(C::class, 'TStringVectorVector'),
        Vector { 'foo' },
      ),
      'Vector<Vector<string>> with incorrect container child' => tuple(
        type_structure(C::class, 'TStringVectorVector'),
        Vector { ImmVector { 'foo' } },
      ),
      'nested shape with missing field' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape('not the field I want' => 'bar'),
        ),
      ),
      'nested shape with incorrect subfield' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape('someString' => 123),
        ),
      ),
      'shape with missing container field' =>
        tuple(type_structure(C::class, 'TShapeWithContainer'), array()),
      'shape with container of wrong kind' => tuple(
        type_structure(C::class, 'TShapeWithContainer'),
        array('container' => Vector { 123 }),
      ),
      'enum' => tuple(
        type_structure(C::class, 'TEnum'),
        ExampleEnum::DERP.'HERP DERP DERP',
      ),
      'vec with wrong value types' => tuple(
        type_structure(C::class, 'TIntVec'),
        vec['foo'],
      ),
      'dict with wrong key types' => tuple(
        type_structure(C::class, 'TStringStringDict'),
        dict[123 => 'foo'],
      ),
      'dict with wrong value types' => tuple(
        type_structure(C::class, 'TStringStringDict'),
        dict['foo' => 123],
      ),
      'keyset with wrong value types' => tuple(
        type_structure(C::class, 'TStringKeyset'),
        keyset[123, 456],
      ),
    ];
  }

  /**
   * @dataProvider getExampleInvalidTypes
   */
  public function testInvalidTypes<T>(
    TypeStructure<T> $ts,
    mixed $input,
  ): void {
    expect(
      () ==> TypeAssert\matches_type_structure($ts, $input),
    )->toThrow(IncorrectTypeException::class);
  }

  public function testUnsupportedType(): void {
    $ts = type_structure(C::class, 'TStringArray');
    $ts['kind'] = TypeStructureKind::OF_GENERIC;

    expect(
      () ==> TypeAssert\matches_type_structure($ts, null),
    )->toThrow(UnsupportedTypeException::class);
  }

  public function getExampleValidCoercions(
  ): array<string, (mixed, mixed, mixed)> {
    $coercions = [
      'vec<intish string> to vec<int>' => tuple(
        type_structure(C::class, 'TIntVec'),
        vec['123'],
        vec[123],
      ),
      'vec<Stringable> to keyset<string>' => tuple(
        type_structure(C::class, 'TStringKeyset'),
        vec[new TestStringable('foo')],
        keyset['foo'],
      ),
      'array<intish string> to vec<int>' => tuple(
        type_structure(C::class, 'TIntVec'),
        ['123'],
        vec[123],
      ),
      'array<intish string> to keyset<string>' => tuple(
        type_structure(C::class, 'TStringKeyset'),
        vec['123'],
        keyset['123'],
      ),
      'array<string, int> to dict<string, string>' => tuple(
        type_structure(C::class, 'TStringStringDict'),
        ['foo' => 123, 'bar' => 456],
        dict['foo' => '123', 'bar' => '456'],
      ),
    ];
    return Dict\map(
      $this->getExampleValidTypes(),
      $tuple ==> {
        list($ts, $v) = $tuple;
        return tuple($ts, $v, $v);
      },
    )
      |> Dict\merge($$, $coercions)
      |> array_map($x ==> $x, $$);
  }

  /**
   * @dataProvider getExampleValidCoercions
   */
  public function testValidCoercion<T>(
    TypeStructure<T> $ts,
    mixed $value,
    T $expected,
  ): void {
    $actual = TypeCoerce\match_type_structure($ts, $value);
    expect($actual)->toEqual($expected);
  }

  public function getExampleInvalidCoercions(
  ): array<string, (mixed, mixed)> {
    return [
      'vec<non-intish string> to vec<int>' => tuple(
        type_structure(C::class, 'TIntVec'),
        vec['1.23'],
      ),
    ];
  }

  /**
   * @dataProvider getExampleInvalidCoercions
   */
  public function testInvalidCoercion<T>(
    TypeStructure<T> $ts,
    mixed $value,
  ): void {
    expect(
      () ==> TypeCoerce\match_type_structure($ts, $value),
    )->toThrow(TypeCoercionException::class);
  }

  public function testShapeCoercionsInAssertMode(): void {
    // This is for:
    // - json_decode(..., FB_JSON_HACK_ARRAYS)
    // - likely future changes to the implementation of shapes
    $shape = shape('someString' => 'foobar');
    $dict = dict['someString' => 'foobar'];
    $array = ['someString' => 'foobar'];
    $ts = type_structure(C::class, 'TFlatShape');

    expect(TypeAssert\matches_type_structure($ts, $dict))->toBeSame($shape);
    expect(TypeAssert\matches_type_structure($ts, $array))->toBeSame($shape);
  }

  public function testTupleCoercionsInAssertMode(): void {
    // This is for:
    // - json_decode(..., FB_JSON_HACK_ARRAYS)
    // - likely future changes to the implementation of tuples
    $tuple = tuple('foo', 123);
    $vec = vec['foo', 123];
    $array = ['foo', 123];
    $ts = type_structure(C::class, 'TTuple');

    expect(TypeAssert\matches_type_structure($ts, $vec))->toBeSame($tuple);
    expect(TypeAssert\matches_type_structure($ts, $array))->toBeSame($tuple);
  }
}
