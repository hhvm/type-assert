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
use namespace HH\Lib\{C, Dict, Str};

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

  <<__Override>>
  public function coerceType(mixed $value): T {
    if (!$value is KeyedTraversable<_, _>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }

    $kt = $this->getTrace()->withFrame($this->what.'<Tk, _>');
    $vt = $this->getTrace()->withFrame($this->what.'<_, Tv>');

    $tsk = $this->tsk->withTrace($kt);
    $tsv = $this->tsv->withTrace($vt);


    $out = Map {};
    $changed = false;
    foreach ($value as $k => $v) {
      $kk = $tsk->coerceType($k);
      $vv = $tsv->coerceType($v);
      $out[$kk] = $vv;
      $changed = $changed || ($kk !== $k) || ($vv !== $v);
    }

    if (
      $changed === false &&
      \is_a($value, $this->what, /* allow_string = */ true)
    ) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }

    if ($this->what === Map::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $out;
    }

    /* HH_IGNORE_ERROR[4110] */
    return $out->immutable();
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    if (!\is_a($value, $this->what)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }
    assert($value is \ConstMap<_, _>);

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

  <<__Override>>
  public function toString(): string {
    return Str\format(
      '%s<%s, %s>',
      $this->what,
      $this->tsk->toString(),
      $this->tsv->toString(),
    );
  }
}
