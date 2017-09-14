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

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\C;

final class VectorSpec<Tv, T as \ConstVector<Tv>> extends TypeSpec<T> {
  public function __construct(
    private classname<T> $what,
    private TypeSpec<Tv> $inner,
  ) {
    $valid = keyset[Vector::class, ImmVector::class, \ConstVector::class];
    invariant(
      C\contains_key($valid, $what),
      'Only built-in \ConstVector implementations are supported',
    );
  }

  public function coerceType(mixed $value): T {
    if (!$value instanceof Traversable) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }

    $trace = $this->getTrace()->withFrame($this->what.'<T>');
    $map = $container ==>
      $container->map($v ==> $this->inner->withTrace($trace)->coerceType($v));

    if (is_a($value, $this->what)) {
      assert($value instanceof \ConstVector);
      /* HH_IGNORE_ERROR[4110] */
      return $map($value);
    }

    if ($this->what === Vector::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $map(new Vector($value));
    }
    /* HH_IGNORE_ERROR[4110] */
    return $map((new ImmVector($value)));
  }

  public function assertType(mixed $value): T {
    if (!is_a($value, $this->what)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }
    assert($value instanceof \ConstVector);

    // TupleSpec and ShapeSpec may change their values, and can be nested here
    $changed = false;

    $trace = $this->getTrace()->withFrame($this->what.'<T>');
    $new_value = $value->map($x ==> {
      $y = $this->inner->withTrace($trace)->assertType($x);
      $changed = $changed || $x !== $y;
      return $y;
    });

    if (!$changed) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }

    $value = new Vector($new_value);
    if ($this->what === Vector::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }
    /* HH_IGNORE_ERROR[4110] */
    return $value->immutable();
  }
}
