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
      return \HH\FIXME\UNSAFE_CAST<Traversable<mixed>, T>($value);
    }

    if ($this->what === Set::class) {
      return \HH\FIXME\UNSAFE_CAST<Set<Tv>, T>($out);
    }
    return \HH\FIXME\UNSAFE_CAST<ImmSet<Tv>, T>($out->immutable());
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
      return \HH\FIXME\UNSAFE_CAST<\ConstSet<arraykey>, T>(
        $value,
        'is_a() ensures the collection type and $spec->assertType() ensures the inner type.',
      );
    }

    if ($this->what === Set::class) {
      return \HH\FIXME\UNSAFE_CAST<\ConstSet<Tv>, T>(
        $out,
        '$out is a Set and $this->what is also Set.',
      );
    }

    return \HH\FIXME\UNSAFE_CAST<ImmSet<Tv>, T>(
      $out->immutable(),
      'Return ImmSet when the user asks for ConstSet or ImmSet.
       This immutability for ConstSet is not needed, but kept for consistency with MapSpec and VectorSpec.',
    );
  }

  <<__Override>>
  public function toString(): string {
    return $this->what.'<'.$this->inner->toString().'>';
  }
}
