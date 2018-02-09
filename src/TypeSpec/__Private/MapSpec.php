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
use namespace HH\Lib\{C, Dict};

final class MapSpec<Tk as arraykey, Tv, T as \ConstMap<Tk, Tv>>
  extends TypeSpec<T> {

  public function __construct(
    private classname<T> $what,
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
    $valid = keyset[Map::class, ImmMap::class, \ConstMap::class];
    invariant(
      C\contains_key($valid, $what),
      'Only built-in \ConstMap implementations are supported',
    );
  }

  public function coerceType(mixed $value): T {
    if (!$value instanceof KeyedTraversable) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }

    $tsk = $this->tsk;
    $tsv = $this->tsv;

    $kt = $this->getTrace()->withFrame($this->what.'<Tk, _>');
    $vt = $this->getTrace()->withFrame($this->what.'<_, Tv>');

    $out = Map {};
    foreach ($value as $k => $v) {
      $out[$tsk->withTrace($kt)->coerceType($k)] =
        $tsv->withTrace($vt)->coerceType($v);
    }

    if ($this->what === Map::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $out;
    }

    /* HH_IGNORE_ERROR[4110] */
    return $out->immutable();
  }

  public function assertType(mixed $value): T {
    if (!\is_a($value, $this->what)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }
    assert($value instanceof \ConstMap);

    $tsk = $this->tsk;
    $tsv = $this->tsv;
    $kt = $this->getTrace()->withFrame($this->what.'<Tk, _>');
    $vt = $this->getTrace()->withFrame($this->what.'<_, Tv>');

    // TupleSpec and ShapeSpec may change their values, and can be nested here
    $changed = false;

    $tuples = $value->mapWithKey(
      ($k, $v) ==> {
        $k2 = $tsk->withTrace($kt)->assertType($k);
        $v2 = $tsv->withTrace($vt)->assertType($v);
        $changed = $changed || $k2 !== $k || $v2 !== $v;
        return tuple($k2, $v2);
      },
    );
    if (!$changed) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }

    $value = new Map(Dict\from_entries($tuples));
    if ($this->what === Map::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }
    /* HH_IGNORE_ERROR[4110] */
    return $value->immutable();
  }
}
