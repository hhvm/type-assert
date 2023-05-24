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
use namespace HH\Lib\{C, Str};

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
      return \HH\FIXME\UNSAFE_CAST<KeyedTraversable<mixed, mixed>, T>($value);
    }

    if ($this->what === Map::class) {
      return \HH\FIXME\UNSAFE_CAST<Map<arraykey, mixed>, T>($out);
    }

    return \HH\FIXME\UNSAFE_CAST<ImmMap<arraykey, mixed>, T>($out->immutable());
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
    $value as \ConstMap<_, _>;
    $out = Map {};
    $out->reserve($value->count());

    $key_spec = $this->tsk
      ->withTrace($this->getTrace()->withFrame($this->what.'<Tk, _>'));
    $value_spec = $this->tsv
      ->withTrace($this->getTrace()->withFrame($this->what.'<_, Tv>'));

    // EnumSpec may change its values, and can be nested here
    $changed = false;
    foreach ($value as $key => $element) {
      $new_key = $key_spec->assertType($key);
      $new_element = $value_spec->assertType($element);
      $changed = $changed || $new_key !== $key || $new_element !== $element;
      $out[$new_key] = $new_element;
    }

    if (!$changed) {
      // $value has an undenotable type Tk#1, so mixed.
      return \HH\FIXME\UNSAFE_CAST<mixed, T>(
        $value,
        'is_a() ensures the collection type and $spec->assertType() ensures the inner type.',
      );
    }

    if ($this->what === Map::class) {
      return \HH\FIXME\UNSAFE_CAST<Map<Tk, Tv>, T>(
        $out,
        '$out is a Map and $this->what is also Map.',
      );
    }

    return \HH\FIXME\UNSAFE_CAST<ImmMap<Tk, Tv>, T>(
      $out->immutable(),
      'Return ImmMap when the user asks for ConstMap or ImmMap.
       This immutability for ConstMap is not needed, but kept for backwards compatibility.',
    );
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
