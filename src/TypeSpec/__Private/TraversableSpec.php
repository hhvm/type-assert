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
  UnsupportedTypeException,
  TypeCoercionException,
};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Vec;

final class TraversableSpec<Tinner, T as Traversable<Tinner>>
  extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(
    private classname<T> $outer,
    private TypeSpec<Tinner> $inner,
  ) {
  }

  public function assertType(mixed $value): T {
    $frame = $this->outer.'<T>';

    if (!is_a($value, $this->outer)) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), $frame, $value);
    }

    invariant(
      $value instanceof Traversable,
      'expected Traversable, got %s',
      is_object($value) ? get_class($value) : gettype($value),
    );

    // Non-Container traversables may not be rewindable, e.g. generators, so
    // we can't check the values.
    //
    // Iterator::rewind() must exist, but may be a no-op, so we can't trust it.
    if (!$value instanceof Container) {
      throw new UnsupportedTypeException(
        'non-Container Traversable '.get_class($value),
      );
    }

    $trace = $this->getTrace()->withFrame($frame);
    foreach ($value as $v) {
      $this->inner->withTrace($trace)->assertType($v);
    }
    return /* HH_IGNORE_ERROR[4110] */ $value;
  }
}
