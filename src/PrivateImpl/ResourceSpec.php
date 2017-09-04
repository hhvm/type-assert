<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert\PrivateImpl;

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException,
  TypeSpec
};

final class ResourceSpec implements TypeSpec<resource> {
  use NoCoercionSpecTrait<resource>;

  public function assertType(mixed $value): resource {
    if (is_resource($value)) {
      return $value;
    }
    throw IncorrectTypeException::withValue('resource', $value);
  }
}
