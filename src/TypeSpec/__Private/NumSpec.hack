/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec\__Private;


final class NumSpec extends UnionSpec<num> {
  public function __construct() {
    parent::__construct('num', new IntSpec(), new FloatSpec());
  }
}
