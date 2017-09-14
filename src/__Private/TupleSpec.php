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

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException
};
use type Facebook\TypeSpec\TypeSpec;

newtype BogusTuple = (mixed, mixed);

final class TupleSpec extends TypeSpec<BogusTuple> {
  public function __construct(
    private vec<TypeSpec<mixed>> $inners
  ) {
  }

  public function coerceType(mixed $value): BogusTuple {
    if (!(is_array($value) || is_vec($value))) {
      throw TypeCoercionException::withValue('tuple', $value);
    }
    assert($value instanceof Traversable);
    $values = vec($value);

    $count = count($values);
    if ($count !== count($this->inners)) {
      throw TypeCoercionException::withValue('tuple', $value);
    }

    $out = vec[];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]->coerceType($values[$i]);
    }
    return self::vecToTuple($out);
  }

  public function assertType(mixed $value): BogusTuple {
    if (is_array($value)) {
      $value = vec($value);
    } else if (!is_vec($value)) {
      throw IncorrectTypeException::withValue('tuple', $value);
    }
    $values = $value;

    $count = count($values);
    if ($count !== count($this->inners)) {
      throw IncorrectTypeException::withValue('tuple', $value);
    }

    $out = vec[];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]->assertType($values[$i]);
    }
    return self::vecToTuple($out);
  }

  private static function vecToTuple(
    vec<mixed> $tuple,
  ): BogusTuple {
    if (is_vec(tuple('foo'))) {
      /* HH_IGNORE_ERROR[4110] */
      return $tuple;
    }
    /* HH_IGNORE_ERROR[4007] */
    return (array) $tuple;
  }
}
