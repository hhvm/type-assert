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

final class TraversableSpec<Tinner, T as Traversable<Tinner>>
  extends TypeSpec<T> {
  use NoCoercionSpecTrait<T>;

  public function __construct(
    private classname<T> $outer,
    private TypeSpec<Tinner> $inner,
  ) {
  }

  <<__Override>>
  public function assertType(mixed $value): T {
    $frame = $this->outer.'<T>';

    // Switch is needed as values such as PHP arrays pass instanceof, but not is_a()
    switch ($this->outer) {
      case Container::class:
        $valid_outer = $value is Container<_>;
        break;
      case Traversable::class:
        $valid_outer = $value is Traversable<_>;
        break;
      default:
        $valid_outer = \is_a($value, $this->outer);
    }

    if (!$valid_outer) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $frame,
        $value,
      );
    }

    invariant(
      $value is Traversable<_>,
      'expected Traversable, got %s',
      \is_object($value) ? \get_class($value) : \gettype($value),
    );

    // Non-Container traversables may not be rewindable, e.g. generators, so
    // we can't check the values.
    //
    // Iterator::rewind() must exist, but may be a no-op, so we can't trust it.
    if (!$value is Container<_>) {
      throw new UnsupportedTypeException(
        'non-Container Traversable '.\get_class($value),
      );
    }

    $trace = $this->getTrace()->withFrame($frame);
    foreach ($value as $v) {
      $this->inner->withTrace($trace)->assertType($v);
    }
    return /* HH_IGNORE_ERROR[4110] */ $value;
  }

  <<__Override>>
  public function toString(): string {
    return Traversable::class.'<'.$this->inner->toString().'>';
  }
}
