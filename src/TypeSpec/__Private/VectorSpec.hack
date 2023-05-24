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

final class VectorSpec<Tv, T as \ConstVector<Tv>> extends TypeSpec<T> {
  public function __construct(
    private classname<T> $what,
    private TypeSpec<Tv> $inner,
  ) {
    $valid = keyset[Vector::class, ImmVector::class, \ConstVector::class];
    invariant(
      C\contains_key($valid, $what),
      'Only built-in \ConstVector implementations are supported',
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

    $out = Vector {};
    $changed = false;
    foreach ($value as $v) {
      $vv = $ts->coerceType($v);
      $changed = $changed || ($v !== $vv);
      $out[] = $vv;
    }

    if ($changed === false && \is_a($value, $this->what)) {
      return \HH\FIXME\UNSAFE_CAST<Traversable<mixed>, T>($value);
    }

    if ($this->what === Vector::class) {
      return \HH\FIXME\UNSAFE_CAST<Vector<Tv>, T>($out);
    }

    return \HH\FIXME\UNSAFE_CAST<ImmVector<Tv>, T>($out->immutable());
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
    $value as \ConstVector<_>;

    $out = Vector {};
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
      return \HH\FIXME\UNSAFE_CAST<\ConstVector<mixed>, T>(
        $value,
        'is_a() ensures the collection type and $spec->assertType() ensures the inner type.',
      );
    }

    if ($this->what === Vector::class) {
      return \HH\FIXME\UNSAFE_CAST<Vector<Tv>, T>(
        $out,
        '$out is a Vector and $this->what is also Vector.',
      );
    }

    return \HH\FIXME\UNSAFE_CAST<ImmVector<Tv>, T>(
      $out->immutable(),
      'Return ImmVector when the user asks for ConstVector or ImmVector.
       This immutability for ConstVector is not needed, but kept for backwards compatibility.',
    );
  }

  <<__Override>>
  public function toString(): string {
    return $this->what.'<'.$this->inner->toString().'>';
  }
}
