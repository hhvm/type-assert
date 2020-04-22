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

final class NullSpec extends TypeSpec<null> {
  use NoCoercionSpecTrait<null>;

  <<__Override>>
  public function assertType(mixed $value): null {
    if ($value is nonnull) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->toString(),
        $value,
      );
    }
    return null;
  }

  <<__Override>>
  public function toString(): string {
    return 'null';
  }
}
