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

use namespace Facebook\{TypeCoerce, TypeSpec};

use function Facebook\FBExpect\expect;

final class ReifiedGenericsTest extends \Facebook\HackTest\HackTest {
  const type TString = string;

  public function testString(): void {
    expect(matches<this::TString>('foo'))->toBeSame('foo');
    expect(() ==> matches<this::TString>(123))
      ->toThrow(IncorrectTypeException::class);
  }

  const type TVecOfStrings = vec<string>;

  public function testVecOfStrings(): void {
    expect(matches<this::TVecOfStrings>(vec['foo', 'bar']))
      ->toBeSame(vec['foo', 'bar']);
    expect(() ==> matches<this::TVecOfStrings>(vec[123, 123]))
      ->toThrow(IncorrectTypeException::class);
  }

  const type TShapeOfVecAndDicts = shape(
    'vec' => vec<string>,
    'dict' => dict<int, int>,
  );

  public function testShapeOfVecAndDicts(): void {
    $valid = shape('vec' => vec['foo', 'bar'], 'dict' => dict[1 => 2]);
    $coercable = dict['vec' => vec['foo', 'bar'], 'dict' => darray[1 => 2]];

    expect(matches<this::TShapeOfVecAndDicts>($valid))->toBeSame($valid);
    if (darray[] !== dict[]) {
      // They are equivalent as of v4.103
      expect(() ==> matches<this::TShapeOfVecAndDicts>($coercable))
        ->toThrow(IncorrectTypeException::class);
    }
    expect(TypeCoerce\match<this::TShapeOfVecAndDicts>($coercable))
      ->toBeSame($valid);
    expect(() ==> TypeCoerce\match<this::TShapeOfVecAndDicts>('hello'))
      ->toThrow(TypeCoercionException::class);
  }

  public function testInlineTypes(): void {
    $valid = shape('foo' => 123);
    $coercable = shape('foo' => '123');
    expect(matches<shape('foo' => int)>($valid))->toEqual($valid);
    expect(matches<shape('foo' => int, ...)>($valid))->toEqual($valid);
    expect(TypeCoerce\match<shape('foo' => int, ...)>($valid))->toEqual($valid);
    expect(TypeCoerce\match<shape('foo' => int, ...)>($coercable))->toEqual(
      $valid,
    );
  }

  public function testToString(): void {
    expect(TypeSpec\of<shape('foo' => vec<string>)>()->toString())->toEqual(
      "shape(\n  'foo' => HH\\vec<string>,\n)",
    );
    expect(TypeSpec\of<shape('foo' => vec<string>, ...)>()->toString())
      ->toEqual("shape(\n  'foo' => HH\\vec<string>,\n  ...\n)");
  }

  public function testNullType(): void {
    expect(TypeSpec\of<null>()->toString())->toEqual('null');
    expect(
      TypeSpec\of<dict<string, ?dict<string, ?dict<string, null>>>>()
        ->toString(),
    )->toEqual('HH\dict<string, ?HH\dict<string, ?HH\dict<string, null>>>');
  }

  public function testNonNullType(): void {
    expect(TypeSpec\of<nonnull>()->toString())->toEqual('nonnull');
    expect(
      TypeSpec\of<shape(
        ?'optional_but_never_null' => nonnull,
        'required_but_may_be_null' => mixed,
        'neither' => nonnull,
        ?'both' => mixed,
      )>()
        ->toString(),
    )->toEqual(<<<'TYPE'
shape(
  ?'optional_but_never_null' => nonnull,
  'required_but_may_be_null' => mixed,
  'neither' => nonnull,
  ?'both' => mixed,
)
TYPE
    );
  }
}
