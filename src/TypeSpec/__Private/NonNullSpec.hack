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

use type Facebook\TypeAssert\IncorrectTypeException;
use type Facebook\TypeSpec\TypeSpec;

final class NonNullSpec extends TypeSpec<nonnull> {
  use NoCoercionSpecTrait<nonnull>;

  <<__Override>>
  public function assertType(mixed $value): nonnull {
    if ($value is null) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->toString(),
        $value,
      );
    }
    return $value;
  }

  <<__Override>>
  public function toString(): string {
    return 'nonnull';
  }
}
