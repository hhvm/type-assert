<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeSpec\TypeSpec;

final class NumSpec extends UnionSpec<num> {
  public function __construct() {
    parent::__construct(
      'num',
      new IntSpec(),
      new FloatSpec(),
    );
  }
}
