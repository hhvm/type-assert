<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert\PrivateImpl\TypeSpec;

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException
};

final class ArrayKeySpec extends UnionSpec<arraykey> {
  public function __construct() {
    parent::__construct(
      'arraykey',
      new StringSpec(),
      new IntSpec(),
    );
  }
}

function arraykey(): TypeSpec<arraykey> {
  return new ArrayKeySpec();
}
