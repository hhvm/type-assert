<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert;

use \FredEmmott\TypeAssert\TestFixtures\ExampleEnum;
use \FredEmmott\TypeAssert\TestFixtures\TypeConstants as C;

final class TypeStructureTest extends \PHPUnit\Framework\TestCase {
  public function getExampleValidTypes(
  ): array<string, (mixed,mixed)> {
    return [
      'int' => tuple(
        type_structure(C::class, 'TInt'),
        123,
      ),
      'bool' => tuple(
        type_structure(C::class, 'TBool'),
        true,
      ),
      'float' => tuple(
        type_structure(C::class, 'TFloat'),
        1.23,
      ),
      'string' => tuple(
        type_structure(C::class, 'TString'),
        'foo',
      ),
      'int-as-num' => tuple(
        type_structure(C::class, 'TNum'),
        123,
      ),
      'float-as-num' => tuple(
        type_structure(C::class, 'TNum'),
        1.23,
      ),
      'string-as-arraykey' => tuple(
        type_structure(C::class, 'TArrayKey'),
        'foo',
      ),
      'int-as-arraykey' => tuple(
        type_structure(C::class, 'TArrayKey'),
        123,
      ),
      'tuple' => tuple(
        type_structure(C::class, 'TTuple'),
        tuple('foo', 123),
      ),
      'empty array<string>' => tuple(
        type_structure(C::class, 'TStringArray'),
        [],
      ),
      'array<string>' => tuple(
        type_structure(C::class, 'TStringArray'),
        ['123', '456'],
      ),
      'empty array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        [],
      ),
      'array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        ['foo' => 'bar', 'herp' => 'derp'],
      ),
      'string as ?string' => tuple(
        type_structure(C::class, 'TNullableString'),
        'hello, world',
      ),
      'null as ?string' => tuple(
        type_structure(C::class, 'TNullableString'),
        null,
      ),
      'stdClass' => tuple(
        type_structure(C::class, 'TStdClass'),
        new \stdClass(),
      ),
      'empty Vector<string>' => tuple(
        type_structure(C::class, 'TStringVector'),
        Vector { },
      ),
      'Vector<string>' => tuple(
        type_structure(C::class, 'TStringVector'),
        Vector { 'foo', 'bar' },
      ),
      'empty Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { },
      ),
      'Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 'derp' },
      ),
      'shape with missing ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 'foo'),
      ),
      'shape with null ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape(
          'someString' => 'foo',
          'someNullable' => null,
        ),
      ),
      'shape with string ?string field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape(
          'someString' => 'foo',
          'someNullable' => 'string',
        ),
      ),
      'shape with extra field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape(
          'someString' => 'foo',
          'some junk' => 'bar',
        ),
      ),
      'nested shape' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape(
            'someString' => 'bar',
          ),
        ),
      ),
      'enum' => tuple(
        type_structure(C::class, 'TEnum'),
        ExampleEnum::DERP,
      ),
    ];
  }

  /**
   * @dataProvider getExampleValidTypes
   */
  public function testValidType<T>(
    TypeStructure<T> $ts,
    mixed $input,
  ): void {
    $this->assertSame(
      $input,
      TypeAssert::matchesTypeStructure(
        $ts,
        $input,
      ),
    );
  }

  public function getExampleInvalidTypes(
  ): array<string, (mixed,mixed)> {
    return [
      '"123" as int' => tuple(
        type_structure(C::class, 'TInt'),
        '123',
      ),
      '1 as bool' => tuple(
        type_structure(C::class, 'TBool'),
        1,
      ),
      'int as float' => tuple(
        type_structure(C::class, 'TFloat'),
        123,
      ),
      'int as string' => tuple(
        type_structure(C::class, 'TString'),
        123,
      ),
      'string as num' => tuple(
        type_structure(C::class, 'TNum'),
        '123',
      ),
      'float as arraykey' => tuple(
        type_structure(C::class, 'TArrayKey'),
        1.23,
      ),
      'incorrect tuple field types' => tuple(
        type_structure(C::class, 'TTuple'),
        tuple('foo', '123'),
      ),
      'too many tuple fields' => tuple(
        type_structure(C::class, 'TTuple'),
        tuple('foo', 123, 456),
      ),
      'int in array<string>' => tuple(
        type_structure(C::class, 'TStringArray'),
        [123],
      ),
      'int keys in array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        [123 => 'bar', 123 => 'derp'],
      ),
      'int values in array<string, string>' => tuple(
        type_structure(C::class, 'TStringStringArray'),
        ['foo' => 123, 'bar' => 456],
      ),
      '0 as ?string' => tuple(
        type_structure(C::class, 'TNullableString'),
        0,
      ),
      'wrong object type' => tuple(
        type_structure(C::class, 'TStdClass'),
        ImmMap { },
      ),
      'ints in Vector<string>' => tuple(
        type_structure(C::class, 'TStringVector'),
        Vector { 'foo', 123 },
      ),
      'int keys in Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 123 => 'foo' },
      ),
      'int values in Map<string, string>' => tuple(
        type_structure(C::class, 'TStringStringMap'),
        Map { 'foo' => 'bar', 'herp' => 123 },
      ),
      'shape with incorrect field' => tuple(
        type_structure(C::class, 'TFlatShape'),
        shape('someString' => 123),
      ),
      'nested shape with missing field' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape(
            'not the field I want' => 'bar',
          ),
        ),
      ),
      'nested shape with incorrect subfield' => tuple(
        type_structure(C::class, 'TNestedShape'),
        shape(
          'someString' => 'foo',
          'someOtherShape' => shape(
            'someString' => 123,
          ),
        ),
      ),
      'enum' => tuple(
        type_structure(C::class, 'TEnum'),
        ExampleEnum::DERP.'HERP DERP DERP',
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
    $this->expectException(IncorrectTypeException::class);
    TypeAssert::matchesTypeStructure(
      $ts,
      $input,
    );
  }

  public function testUnsupportedType(): void {
    $this->expectException(UnsupportedTypeException::class);
    TypeAssert::matchesTypeStructure(
       type_structure(C::class, 'TVec'),
       /* HH_IGNORE_ERROR[0000] cannot use experimental feature */
       vec[1, 2, 3],
    );
  }
}
