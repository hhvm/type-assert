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

use type Facebook\TypeSpec\TypeSpec;

final class MixedSpec extends TypeSpec<mixed> {
  <<__Override>>
  public function coerceType(mixed $value): mixed {
    return $value;
  }

  <<__Override>>
  public function assertType(mixed $value): mixed {
    return $value;
  }

  <<__Override>>
  public function toString(): string {
    return 'mixed';
  }
}
