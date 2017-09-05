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

final class TupleSpec implements TypeSpec<array<mixed>> {
  public function __construct(
    private vec<TypeSpec<mixed>> $inners
  ) {
  }

  public function coerceType(mixed $value): array<mixed> {
    if (!(is_array($value) || is_vec($value))) {
      throw TypeCoercionException::withValue('tuple', $value);
    }
    assert($value instanceof Traversable);
    $values = vec($value);

    $count = count($values);
    if ($count !== count($this->inners)) {
      throw TypeCoercionException::withValue('tuple', $value);
    }

    $out = [];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]->coerceType($values[$i]);
    }
    return $out;
  }

  public function assertType(mixed $value): array<mixed> {
    if (!is_array($value)) {
      throw IncorrectTypeException::withValue('tuple', $value);
    }
    $values = $value;

    $count = count($values);
    if ($count !== count($this->inners)) {
      throw IncorrectTypeException::withValue('tuple', $value);
    }

    $out = [];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]->assertType($values[$i]);
    }
    return $out;
  }
}
