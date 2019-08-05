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

final class OptionalSpec<T> extends TypeSpec<T> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  <<__Override>>
  public function isOptional(): bool {
    return true;
  }

  <<__Override>>
  public function coerceType(mixed $value): T {
    return $this->inner->withTrace($this->getTrace())->coerceType($value);
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    return $this->inner->withTrace($this->getTrace())->assertType($value);
  }

  <<__Override>>
  public function toString(): string {
    return $this->inner->toString();
  }
}
