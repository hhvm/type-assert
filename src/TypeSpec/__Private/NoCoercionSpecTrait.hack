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

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};

trait NoCoercionSpecTrait<T> {
  require extends \Facebook\TypeSpec\TypeSpec<T>;

  final public function coerceType(mixed $value): T {
    try {
      return $this->assertType($value);
    } catch (IncorrectTypeException $e) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        $e->getExpectedType(),
        $value,
      );
    }
  }
}
