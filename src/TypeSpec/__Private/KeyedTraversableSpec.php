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

use type Facebook\TypeAssert\{IncorrectTypeException, UnsupportedTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Vec;

final class KeyedTraversableSpec<Tk, Tv, T as KeyedTraversable<Tk, Tv>>
extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(
    private classname<T> $outer,
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
  }

  public function assertType(mixed $value): T {
    if (!is_a($value, $this->outer)) {
      throw
        IncorrectTypeException::withValue($this->getTrace(), $this->outer.'<Tk, Tv>', $value);
    }

    invariant(
      $value instanceof KeyedTraversable,
      'expected KeyedTraversable, got %s',
      is_object($value) ? get_class($value) : gettype($value),
    );

    // Non-Container traversables may not be rewindable, e.g. generators, so
    // we can't check the values.
    //
    // Iterator::rewind() must exist, but may be a no-op, so we can't trust it.
    if (!$value instanceof KeyedContainer) {
      throw new UnsupportedTypeException(
        'non-KeyedContainer KeyedTraversable '.get_class($value),
      );
    }

    $key_trace = $this->getTrace()->withFrame($this->outer.'<Tk, _>');
    $value_trace= $this->getTrace()->withFrame($this->outer.'<_, Tv>');
    $tsk = $this->tsk->withTrace($key_trace);
    $tsv = $this->tsv->withTrace($value_trace);
    foreach ($value as $k => $v) {
      $tsk->assertType($k);
      $tsv->assertType($v);
    }
    return /* HH_IGNORE_ERROR[4110] */ $value;
  }
}
