<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert {

  interface TypeSpec<+T> {
    public function coerceType(mixed $value): T;
    public function assertType(mixed $value): T;
  }

}

namespace Facebook\TypeAssert\TypeSpec {

  use type Facebook\TypeAssert\TypeSpec;
  use type Facebook\TypeAssert\PrivateImpl\{
    BoolSpec,
    FloatSpec,
    IntSpec,
    NullableSpec,
    StringSpec,
    UnionSpec
  };

  function arraykey(): TypeSpec<arraykey> {
    return new UnionSpec(
      'arraykey',
      namespace\string(),
      namespace\int(),
    );
  }

  function bool(): TypeSpec<bool> {
    return new BoolSpec();
  }

  function float(): TypeSpec<float> {
    return new FloatSpec();
  }

  function int(): TypeSpec<int> {
    return new IntSpec();
  }

  function nullable<T>(TypeSpec<T> $inner): TypeSpec<?T> {
    return new NullableSpec($inner);
  }

  function num(): TypeSpec<num> {
    return new UnionSpec(
      'num',
      namespace\int(),
      namespace\float(),
    );
  }

  function string(): TypeSpec<string> {
    return new StringSpec();
  }
}
