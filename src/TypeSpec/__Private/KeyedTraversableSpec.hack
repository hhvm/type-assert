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

use type Facebook\TypeAssert\{IncorrectTypeException, UnsupportedTypeException};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Str;

final class KeyedTraversableSpec<Tk, Tv, T as KeyedTraversable<Tk, Tv>>
  extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(
    private classname<T> $outer,
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    // Switch is needed as values such as PHP arrays pass instanceof, but not is_a()
    switch ($this->outer) {
      case KeyedContainer::class:
        $valid_outer = $value is KeyedContainer<_, _>;
        break;
      case KeyedTraversable::class:
        $valid_outer = $value is KeyedTraversable<_, _>;
        break;
      default:
        $valid_outer = \is_a($value, $this->outer);
    }

    if (!$valid_outer) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->outer.'<Tk, Tv>',
        $value,
      );
    }

    invariant(
      $value is KeyedTraversable<_, _>,
      'expected KeyedTraversable, got %s',
      \is_object($value) ? \get_class($value) : \gettype($value),
    );

    // Non-Container traversables may not be rewindable, e.g. generators, so
    // we can't check the values.
    //
    // Iterator::rewind() must exist, but may be a no-op, so we can't trust it.
    if (!$value is KeyedContainer<_, _>) {
      throw new UnsupportedTypeException(
        'non-KeyedContainer KeyedTraversable '.\get_class($value),
      );
    }

    $key_trace = $this->getTrace()->withFrame($this->outer.'<Tk, _>');
    $value_trace = $this->getTrace()->withFrame($this->outer.'<_, Tv>');
    $tsk = $this->tsk->withTrace($key_trace);
    $tsv = $this->tsv->withTrace($value_trace);
    foreach ($value as $k => $v) {
      $tsk->assertType($k);
      $tsv->assertType($v);
    }
    return /* HH_IGNORE_ERROR[4110] */ $value;
  }

  <<__Override>>
  public function toString(): string {
    return Str\format(
      '%s<%s, %s>',
      KeyedTraversable::class,
      $this->tsk->toString(),
      $this->tsv->toString(),
    );
  }
}
