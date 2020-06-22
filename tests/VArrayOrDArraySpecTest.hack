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

use namespace Facebook\TypeSpec;
use type Facebook\TypeSpec\TypeSpec;
use function Facebook\FBExpect\expect;

final class VArrayOrDArraySpecTest
  extends TypeSpecTest<varray_or_darray<mixed>> {
  <<__Override>>
  public function getTypeSpec(): TypeSpec<varray_or_darray<int>> {
    return TypeSpec\varray_or_darray(TypeSpec\int());
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, varray_or_darray<int>)> {
    return vec[
      tuple(vec[], varray[]),
      tuple(dict[], darray[]),
      tuple(keyset[], darray[]),
      tuple(vec['123'], varray[123]),
      tuple(varray['123'], varray[123]),
      tuple(varray[123], varray[123]),
      tuple(dict['foo' => '456'], darray['foo' => 456]),
      tuple(Vector {123}, varray[123]),
      tuple(darray['foo' => 123], darray['foo' => 123]),
      tuple(keyset['123'], darray['123' => 123]),
    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple(varray['foo']),
      tuple(vec['foo']),
      tuple(keyset['foo']),
      tuple(darray[123 => 'foo']),
    ];
  }

  <<__Override>>
  public function getToStringExamples(
  ): vec<(TypeSpec<varray_or_darray<mixed>>, string)> {
    return vec[
      tuple(
        TypeSpec\varray_or_darray(TypeSpec\string()),
        'varray_or_darray<string>',
      ),
      tuple(TypeSpec\varray_or_darray(TypeSpec\int()), 'varray_or_darray<int>'),
    ];
  }

  public function testSubtyping(): void {
    $varray = (
      (): varray<int> ==>
        TypeSpec\varray(TypeSpec\int())->assertType(varray[123])
    )();
    $darray = (
      (): darray<arraykey, int> ==>
        TypeSpec\darray(TypeSpec\arraykey(), TypeSpec\int())
          ->assertType(darray['foo' => 123])
    )();
    $widened_varray = ((): varray_or_darray<int> ==> $varray)();
    $widened_darray = ((): varray_or_darray<int> ==> $darray)();
    expect($widened_varray)->toEqual($varray);
    expect($widened_darray)->toEqual($darray);
  }
}
