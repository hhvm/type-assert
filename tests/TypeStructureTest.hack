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

use type Facebook\TypeAssert\TestFixtures\{ExampleEnum, TypeConstants};
use type Facebook\HackTest\DataProvider;

use namespace Facebook\{TypeAssert, TypeCoerce};
use namespace HH\Lib\Dict;

use function Facebook\FBExpect\expect;

final class TypeStructureTest extends \Facebook\HackTest\HackTest {
  public function getExampleValidTypes(): array<string, (mixed, mixed)> {
    return [
      'int' => tuple(type_structure(TypeConstants::class, 'TInt'), 123),
      'bool' => tuple(type_structure(TypeConstants::class, 'TBool'), true),
      'float' => tuple(type_structure(TypeConstants::class, 'TFloat'), 1.23),
      'string' => tuple(type_structure(TypeConstants::class, 'TString'), 'foo'),
      'int-as-num' => tuple(type_structure(TypeConstants::class, 'TNum'), 123),
      'float-as-num' =>
        tuple(type_structure(TypeConstants::class, 'TNum'), 1.23),
      'string-as-arraykey' =>
        tuple(type_structure(TypeConstants::class, 'TArrayKey'), 'foo'),
      'int-as-arraykey' =>
        tuple(type_structure(TypeConstants::class, 'TArrayKey'), 123),
      'tuple' => tuple(
        type_structure(TypeConstants::class, 'TTuple'),
        tuple('foo', 123),
      ),
      'empty array<string>' =>
        tuple(type_structure(TypeConstants::class, 'TStringArray'), []),
      'array<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringArray'),
        ['123', '456'],
      ),
      'empty array<string, string>' =>
        tuple(type_structure(TypeConstants::class, 'TStringStringArray'), []),
      'array<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringArray'),
        ['foo' => 'bar', 'herp' => 'derp'],
      ),
      'string as ?string' => tuple(
        type_structure(TypeConstants::class, 'TNullableString'),
        'hello, world',
      ),
      'null as ?string' =>
        tuple(type_structure(TypeConstants::class, 'TNullableString'), null),
      'stdClass' => tuple(
        type_structure(TypeConstants::class, 'TStdClass'),
        new \stdClass(),
      ),
      'empty Vector<string>' =>
        tuple(type_structure(TypeConstants::class, 'TStringVector'), Vector {}),
      'Vector<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringVector'),
        Vector { 'foo', 'bar' },
      ),
      'Traversable<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntTraversable'),
        Vector { 123, 456 },
      ),
      'array as Container<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntContainer'),
        [123, 456],
      ),
      'Container<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntContainer'),
        Vector { 123, 456 },
      ),
      'KeyedTraversable<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedTraversable'),
        Map { 'foo' => 123 },
      ),
      'KeyedContainer<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedContainer'),
        Map { 'foo' => 123 },
      ),
      'PHP array as KeyedContainer<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedContainer'),
        ['foo' => 123],
      ),
      'empty Map<string, string>' =>
        tuple(type_structure(TypeConstants::class, 'TStringStringMap'), Map {}),
      'Map<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 'derp' },
      ),
      'Vector<Vector<string>>' => tuple(
        type_structure(TypeConstants::class, 'TStringVectorVector'),
        Vector { Vector { 'foo' } },
      ),
      'Vector<Vector<string>> with no outer elems' => tuple(
        type_structure(TypeConstants::class, 'TStringVectorVector'),
        Vector {},
      ),
      'Vector<Vector<string>> with no inner elems' => tuple(
        type_structure(TypeConstants::class, 'TStringVectorVector'),
        Vector { Vector {} },
      ),
      'shape with missing string ?field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape('someString' => 'foo', 'someNullable' => null),
      ),
      'shape with null ?string field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape('someString' => 'foo', 'someNullable' => null),
      ),
      'shape with null ?string ?field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape(
          'someString' => 'foo',
          'someNullable' => null,
          'someOptionalNullable' => null,
        ),
      ),
      'shape with string ?string field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape('someString' => 'foo', 'someNullable' => 'string'),
      ),
      'shape with extra field and implicit subtyping' => tuple(
        type_structure(
          TypeConstants::class,
          'TShapeWithOneFieldAndImplicitSubtypes',
        ),
        shape(
          'someString' => 'foo',
          'herp' => 'derp',
        ),
      ),
      'nested shape' => tuple(
        type_structure(TypeConstants::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' =>
            shape('someString' => 'bar', 'someNullable' => null),
        ),
      ),
      'shape with empty container' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithContainer'),
        array('container' => Vector {}),
      ),
      'shape with non-empty container' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithContainer'),
        array('container' => Vector { 'foo' }),
      ),
      'enum' =>
        tuple(type_structure(TypeConstants::class, 'TEnum'), ExampleEnum::DERP),
      'vec<int>' =>
        tuple(type_structure(TypeConstants::class, 'TIntVec'), vec[1, 2, 3]),
      'vec of shapes' => tuple(
        type_structure(TypeConstants::class, 'TVecOfShapes'),
        vec[shape('someString' => 'foo', 'someNullable' => null)],
      ),
      'vec<vec<string>>' => tuple(
        type_structure(TypeConstants::class, 'TIntVecVec'),
        vec[vec[1, 2, 3], vec[4, 5, 6]],
      ),
      'dict<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringDict'),
        dict[
          'foo' => 'bar',
          'herp' => 'derp',
        ],
      ),
      'dict<string, vec<string>>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringVecDict'),
        dict[
          'foo' => vec['bar', 'baz'],
          'herp' => vec['derp'],
        ],
      ),
      'keyset<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringKeyset'),
        keyset['foo', 'bar', 'baz', 'herp', 'derp'],
      ),
      'empty array as array<>' => tuple(
        type_structure(TypeConstants::class, 'TArrayWithoutGenerics'),
        [],
      ),
      'vec-like array as array<>' => tuple(
        type_structure(TypeConstants::class, 'TArrayWithoutGenerics'),
        ['foo', 'bar'],
      ),
      'dict-like array as array<>' => tuple(
        type_structure(TypeConstants::class, 'TArrayWithoutGenerics'),
        ['foo' => 'bar'],
      ),
      'empty array in array<> shape field' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => []),
      ),
      'vec-like array in array<> shape field' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => ['foo', 'bar']),
      ),
      'dict-like array in array<> shape field' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithArrayWithoutGenerics'),
        shape('one' => true, 'two' => ['foo' => 'bar']),
      ),
    ];
  }

  <<DataProvider('getExampleValidTypes')>>
  public function testValidType<T>(TypeStructure<T> $ts, T $input): void {
    expect(TypeAssert\matches_type_structure($ts, $input))
      ->toBeSame($input);
  }

  public function testAssertedShapeAsShape(): void {
    // most of the runtime is fine with actual PHP arrays, but we need a real
    // darray for the `as` operator
    $x = shape('someString' => 'foo');
    $y = TypeAssert\matches_type_structure(
      type_structure(TypeConstants::class, 'TShapeWithOneField'),
      $x,
    );
    $y as TypeConstants::TShapeWithOneField;
  }

  public function getExampleInvalidTypes(
  ): array<string, (mixed, mixed, vec<string>)> {
    $examples = [
      '"123" as int' =>
        tuple(type_structure(TypeConstants::class, 'TInt'), '123', vec[]),
      '1 as bool' =>
        tuple(type_structure(TypeConstants::class, 'TBool'), 1, vec[]),
      'int as float' =>
        tuple(type_structure(TypeConstants::class, 'TFloat'), 123, vec[]),
      'int as string' =>
        tuple(type_structure(TypeConstants::class, 'TString'), 123, vec[]),
      'string as num' =>
        tuple(type_structure(TypeConstants::class, 'TNum'), '123', vec[]),
      'float as arraykey' =>
        tuple(type_structure(TypeConstants::class, 'TArrayKey'), 1.23, vec[]),
      'incorrect tuple field types' => tuple(
        type_structure(TypeConstants::class, 'TTuple'),
        tuple('foo', '123'),
        vec['tuple[1]'],
      ),
      'too many tuple fields' => tuple(
        type_structure(TypeConstants::class, 'TTuple'),
        tuple('foo', 123, 456),
        vec[],
      ),
      'int in array<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringArray'),
        [123],
        vec['array[0]'],
      ),
      'int keys in array<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringArray'),
        [123 => 'bar', 123 => 'derp'],
        vec['array<Tk, _>'],
      ),
      'int values in array<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringArray'),
        ['foo' => 123, 'bar' => 456],
        vec['array<_, Tv>'],
      ),
      '0 as ?string' => tuple(
        type_structure(TypeConstants::class, 'TNullableString'),
        0,
        vec[],
      ),
      'wrong object type' => tuple(
        type_structure(TypeConstants::class, 'TStdClass'),
        ImmMap {},
        vec[],
      ),
      'ints in Vector<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringVector'),
        Vector { 'foo', 123 },
        vec['HH\\Vector<T>'],
      ),
      'int keys in Map<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringMap'),
        Map { 123 => 'foo' },
        vec['HH\\Map<Tk, _>'],
      ),
      'int values in Map<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 123 },
        vec['HH\\Map<_, Tv>'],
      ),
      'shape with missing field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape(),
        vec['shape[someString]'],
      ),
      'shape with null optional field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape(
          'someString' => 'a',
          'someNullable' => null,
          'someOptional' => null,
        ),
        vec['shape[someOptional]'],
      ),
      'shape with invalid nullable optional field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape(
          'someString' => 'a',
          'someNullable' => null,
          'someOptionalNullable' => 123,
        ),
        vec['shape[someOptionalNullable]'],
      ),
      'shape with incorrect field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape('someString' => 123, 'someNullable' => null),
        vec['shape[someString]'],
      ),
      'shape with incorrect optional field' => tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape(
          'someString' => 'a',
          'someNullable' => null,
          'someOptional' => 123,
        ),
        vec['shape[someOptional]'],
      ),
      'bad value in shape in vec of shapes' => tuple(
        type_structure(TypeConstants::class, 'TVecOfShapes'),
        vec[shape('someString' => 123)],
        vec['vec<T>', 'shape[someString]'],
      ),
      'string in Traversable<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntTraversable'),
        Vector { 123, '456' },
        vec['HH\\Traversable<T>'],
      ),
      'string in Container<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntContainer'),
        Vector { 123, '456' },
        vec['HH\\Container<T>'],
      ),
      'string value in KeyedTraversable<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedTraversable'),
        Map { 'foo' => 'bar' },
        vec['HH\\KeyedTraversable<_, Tv>'],
      ),
      'int key in KeyedTraversable<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedTraversable'),
        Map { 123 => 456 },
        vec['HH\\KeyedTraversable<Tk, _>'],
      ),
      'string value in KeyedContainer<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedContainer'),
        Map { 'foo' => 'bar' },
        vec['HH\\KeyedContainer<_, Tv>'],
      ),
      'int key in KeyedContainer<string, int>' => tuple(
        type_structure(TypeConstants::class, 'TStringIntKeyedContainer'),
        Map { 123 => 456 },
        vec['HH\\KeyedContainer<Tk, _>'],
      ),
      'Vector<Vector<string>> with non-container child' => tuple(
        type_structure(TypeConstants::class, 'TStringVectorVector'),
        Vector { 'foo' },
        vec['HH\\Vector<T>'],
      ),
      'Vector<Vector<string>> with incorrect container child' => tuple(
        type_structure(TypeConstants::class, 'TStringVectorVector'),
        Vector { ImmVector { 'foo' } },
        vec['HH\\Vector<T>'],
      ),
      'nested shape with missing field' => tuple(
        type_structure(TypeConstants::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape('not the field I want' => 'bar'),
        ),
        vec['shape[someOtherShape]', 'shape[someString]'],
      ),
      'nested shape with incorrect subfield' => tuple(
        type_structure(TypeConstants::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape('someString' => 123),
        ),
        vec['shape[someOtherShape]', 'shape[someString]'],
      ),
      'shape with missing container field' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithContainer'),
        array(),
        vec['shape[container]'],
      ),
      'shape with container of wrong kind' => tuple(
        type_structure(TypeConstants::class, 'TShapeWithContainer'),
        array('container' => Vector { 123 }),
        vec['shape[container]', 'HH\\Vector<T>'],
      ),
      'enum' => tuple(
        type_structure(TypeConstants::class, 'TEnum'),
        ExampleEnum::DERP.'HERP DERP DERP',
        vec[],
      ),
      'vec with wrong value types' => tuple(
        type_structure(TypeConstants::class, 'TIntVec'),
        vec['foo'],
        vec['vec<T>'],
      ),
      'dict with wrong key types' => tuple(
        type_structure(TypeConstants::class, 'TStringStringDict'),
        dict[123 => 'foo'],
        vec['dict<Tk, _>'],
      ),
      'dict with wrong value types' => tuple(
        type_structure(TypeConstants::class, 'TStringStringDict'),
        dict['foo' => 123],
        vec['dict<_, Tv>'],
      ),
      'keyset with wrong value types' => tuple(
        type_structure(TypeConstants::class, 'TStringKeyset'),
        keyset[123, 456],
        vec['keyset<T>'],
      ),
    ];

    if (\HHVM_VERSION_ID >= 32300) {
      $examples['shape with missing nullable field'] = tuple(
        type_structure(TypeConstants::class, 'TFlatShape'),
        shape('someString' => 'foo'),
        vec['shape[someNullable]'],
      );
      $examples['shape with extra fields'] = tuple(
        type_structure(TypeConstants::class, 'TShapeWithOneField'),
        shape('someString' => 'string', 'herp' => 'derp'),
        vec['shape[herp]'],
      );
    }
    return $examples;
  }

  <<DataProvider('getExampleInvalidTypes')>>
  public function testInvalidTypes<T>(
    TypeStructure<T> $ts,
    mixed $input,
    vec<string> $frames,
  ): void {
    $e = null;
    try {
      TypeAssert\matches_type_structure($ts, $input);
    } catch (IncorrectTypeException $caught) {
      $e = $caught;
    }

    $e = expect($e)->toBeInstanceOf(IncorrectTypeException::class);

    expect($e->getSpecTrace()->getFrames())->toBeSame(
      $frames,
      'error trace differs (%s)',
      $e->getMessage(),
    );
  }

  public function testUnsupportedType(): void {
    $ts = type_structure(TypeConstants::class, 'TStringArray');
    $ts['kind'] = TypeStructureKind::OF_GENERIC;

    /* HH_IGNORE_ERROR[4110] */
    expect(() ==> TypeAssert\matches_type_structure($ts, null))->toThrow(
      UnsupportedTypeException::class,
    );
  }

  public function getExampleValidCoercions(
  ): array<string, (mixed, mixed, mixed)> {
    $coercions = [
      'vec<intish string> to vec<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntVec'),
        vec['123'],
        vec[123],
      ),
      'vec<Stringable> to keyset<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringKeyset'),
        vec[new TestStringable('foo')],
        keyset['foo'],
      ),
      'array<intish string> to vec<int>' => tuple(
        type_structure(TypeConstants::class, 'TIntVec'),
        ['123'],
        vec[123],
      ),
      'array<intish string> to keyset<string>' => tuple(
        type_structure(TypeConstants::class, 'TStringKeyset'),
        vec['123'],
        keyset['123'],
      ),
      'array<string, int> to dict<string, string>' => tuple(
        type_structure(TypeConstants::class, 'TStringStringDict'),
        ['foo' => 123, 'bar' => 456],
        dict['foo' => '123', 'bar' => '456'],
      ),
      'shape with implicit subtyping and extra fields' => tuple(
        type_structure(
          TypeConstants::class,
          'TShapeWithOneFieldAndImplicitSubtypes',
        ),
        shape('someString' => 'foo', 'herp' => 'derp'),
        shape('someString' => 'foo', 'herp' => 'derp'),
      ),
    ];

    if (\HHVM_VERSION_ID >= 32300) {
      $coercions['shape with extra fields'] = tuple(
        type_structure(TypeConstants::class, 'TShapeWithOneField'),
        shape('someString' => 'foo', 'herp' => 'derp'),
        shape('someString' => 'foo'),
      );
    } else {
      $coercions['shape with extra fields'] = tuple(
        type_structure(TypeConstants::class, 'TShapeWithOneField'),
        shape('someString' => 'foo', 'herp' => 'derp'),
        shape('someString' => 'foo', 'herp' => 'derp'),
      );
    }

    return Dict\map(
      $this->getExampleValidTypes(),
      $tuple ==> {
        list($ts, $v) = $tuple;
        return tuple($ts, $v, $v);
      },
    )
      |> Dict\merge($$, $coercions)
      |> \array_map($x ==> $x, $$);
  }

  <<DataProvider('getExampleValidCoercions')>>
  public function testValidCoercion<T>(
    TypeStructure<T> $ts,
    mixed $value,
    T $expected,
  ): void {
    $actual = TypeCoerce\match_type_structure($ts, $value);
    expect($actual)->toBePHPEqual($expected);
  }

  public function getExampleInvalidCoercions(): array<string, (mixed, mixed)> {
    return [
      'vec<non-intish string> to vec<int>' =>
        tuple(type_structure(TypeConstants::class, 'TIntVec'), vec['1.23']),
    ];
  }

  <<DataProvider('getExampleInvalidCoercions')>>
  public function testInvalidCoercion<T>(
    TypeStructure<T> $ts,
    mixed $value,
  ): void {
    expect(() ==> TypeCoerce\match_type_structure($ts, $value))->toThrow(
      TypeCoercionException::class,
    );
  }

  public function testShapeCoercionsInAssertMode(): void {
    // This is for:
    // - json_decode(..., FB_JSON_HACK_ARRAYS)
    // - likely future changes to the implementation of shapes
    $shape = shape('someString' => 'foobar', 'someNullable' => null);
    $dict = dict['someString' => 'foobar', 'someNullable' => null];
    $array = ['someString' => 'foobar', 'someNullable' => null];
    $ts = type_structure(TypeConstants::class, 'TFlatShape');

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
    $ts = type_structure(TypeConstants::class, 'TTuple');

    expect(TypeAssert\matches_type_structure($ts, $vec))->toBeSame($tuple);
    expect(TypeAssert\matches_type_structure($ts, $array))->toBeSame($tuple);
  }

  public function testThrowsUnsupportedTypeForGenerators(): void {
    $ts = type_structure(TypeConstants::class, 'TIntTraversable');
    $generator = (
      (): \Generator<int, int, void> ==> {
        yield 123;
      }
    )();

    expect(() ==> TypeAssert\matches_type_structure($ts, $generator))->toThrow(
      UnsupportedTypeException::class,
    );

    $ts = type_structure(TypeConstants::class, 'TStringIntKeyedTraversable');
    $generator = (
      (): \Generator<string, int, void> ==> {
        yield 'foo' => 123;
      }
    )();

    expect(() ==> TypeAssert\matches_type_structure($ts, $generator))->toThrow(
      UnsupportedTypeException::class,
    );
  }
}
