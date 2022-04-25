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

  <<__Override>>
  public function coerceType(mixed $value): T {
    if (!$value is Traversable<_>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        $this->what,
        $value,
      );
    }

    $trace = $this->getTrace()->withFrame($this->what.'<T>');
    $ts = $this->inner->withTrace($trace);
    $changed = false;
    $out = Set {};
    foreach ($value as $v) {
      $vv = $ts->coerceType($v);
      $changed = $changed || ($vv !== $v);
      $out[] = $vv;
    }

    if ($changed === false && \is_a($value, $this->what)) {
      /* HH_IGNORE_ERROR[4110] */
      return $value;
    }

    if ($this->what === Set::class) {
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

    $value as \ConstSet<_>;
    $out = Set {};
    $out->reserve($value->count());

    $spec =
      $this->inner->withTrace($this->getTrace()->withFrame($this->what.'<T>'));

    // EnumSpec may change its values, and can be nested here
    $changed = false;
    foreach ($value as $element) {
      $new_element = $spec->assertType($element);
      $changed = $changed || $new_element !== $element;
      $out[] = $new_element;
    }

    if (!$changed) {
      /* HH_IGNORE_ERROR[4110] is_a() ensures the collection type
         and $spec->assertType() ensures the inner type. */
      return $value;
    }

    if ($this->what === Set::class) {
      /* HH_IGNORE_ERROR[4110] $out is a Set and $this->what is also Set. */
      return $out;
    }

    /* HH_IGNORE_ERROR[4110] Return ImmSet when the user asks for ConstSet or ImmSet.
       This immutability for ConstSet is not needed, but kept for consistency with MapSpec and VectorSpec. */
    return $out->immutable();
  }

  <<__Override>>
  public function toString(): string {
    return $this->what.'<'.$this->inner->toString().'>';
  }
}
