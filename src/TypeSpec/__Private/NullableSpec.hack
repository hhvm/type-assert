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
use type Facebook\TypeSpec\TypeSpec;

final class NullableSpec<T> extends TypeSpec<?T> {
  public function __construct(private TypeSpec<T> $inner) {
    invariant(
      !$inner is OptionalSpec<_>,
      'OptionalSpec should be the outermost spec',
    );
  }

  <<__Override>>
  public function coerceType(mixed $value): ?T {
    if ($value === null) {
      return null;
    }
    try {
      return $this->inner->coerceType($value);
    } catch (TypeCoercionException $e) {
      throw new TypeCoercionException(
        $this->getTrace(),
        '?'.$e->getTargetType(),
        $e->getActualType(),
      );
    }
  }

  <<__Override>>
  public function assertType(mixed $value): ?T {
    if ($value === null) {
      return null;
    }
    try {
      return $this->inner->assertType($value);
    } catch (IncorrectTypeException $e) {
      throw new IncorrectTypeException(
        $this->getTrace(),
        '?'.$e->getExpectedType(),
        $e->getActualType(),
      );
    }
  }

  <<__Override>>
  public function toString(): string {
    return '?'.$this->inner->toString();
  }
}
