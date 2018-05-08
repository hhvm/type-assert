<?hh // strict
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
use namespace HH\Lib\C;

final class SetSpec<Tv as arraykey, T as \ConstSet<Tv>> extends TypeSpec<T> {
  public function __construct(
    private classname<T> $what,
    private TypeSpec<Tv> $inner,
  ) {
    $valid = keyset[Set::class, ImmSet::class, \ConstSet::class];
    invariant(
      C\contains_key($valid, $what),
      'Only built-in \ConstSet implementations are supported',
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

    if (\is_a($value, $this->what)) {
      assert($value instanceof \ConstSet);
      /* HH_IGNORE_ERROR[4110] */
      return $map($value);
    }

    if ($this->what === Set::class) {
      /* HH_IGNORE_ERROR[4110] */
      return $map(new Set($value));
    }
    /* HH_IGNORE_ERROR[4110] */
    return $map((new ImmSet($value)));
  }

  public function assertType(mixed $value): T {
    if (!\is_a($value, $this->what)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }

    assert($value instanceof \ConstSet);

    $trace = $this->getTrace()->withFrame($this->what.'<T>');
    $value->filter($x ==> {
      $this->inner->withTrace($trace)->assertType($x);
      return false;
    });
    /* HH_IGNORE_ERROR[4110] */
    return $value;
  }
}
