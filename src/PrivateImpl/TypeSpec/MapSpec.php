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
use namespace HH\Lib\C;

final class MapSpec<Tk as arraykey, Tv, T as \ConstMap<Tk, Tv>>
  extends TypeSpec<T> {

  public function __construct(
    private classname<T> $what,
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
    $valid = keyset[
      Map::class,
      ImmMap::class,
      \ConstMap::class,
    ];
    invariant(
      C\contains_key($valid, $what),
      'Only built-in \ConstMap implementations are supported',
    );
  }

  public function coerceType(mixed $value): T {
    if (!$value instanceof KeyedTraversable) {
      throw TypeCoercionException::withValue($this->what, $value);
    }

    $tsk = $this->tsk;
    $tsv = $this->tsv;

    $out = Map {};
    foreach ($value as $k => $v) {
      $out[$tsk->coerceType($k)] = $tsv->coerceType($v);
    }

    if ($this->what === Map::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $out;
    }

    /* HH_IGNORE_ERROR[4110] */
    return $out->immutable();
  }

  public function assertType(mixed $value): T {
    if (!is_a($value, $this->what)) {
      throw IncorrectTypeException::withValue($this->what, $value);
    }
    assert($value instanceof \ConstMap);
    $tsk = $this->tsk;
    $tsv = $this->tsv;
    $value->filterWithKey(
      ($k, $v) ==> {
        $tsk->assertType($k);
        $tsv->assertType($v);
        return false;
      }
    );
    /* HH_IGNORE_ERROR[4110] */
    return $value;
  }
}
