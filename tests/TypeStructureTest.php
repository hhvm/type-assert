<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert;

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
    ];
  }
  /**
   * @dataProvider getExampleValidTypes
   */
  public function testValidTypes<T>(
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
}
