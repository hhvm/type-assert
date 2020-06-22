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
use namespace HH\Lib\Vec;

final class VarraySpec<T> extends TypeSpec<varray<T>> {
  public function __construct(
    private TypeSpec<T> $inner,
  ) {
  }

  <<__Override>>
  public function coerceType(mixed $value): varray<T> {
    if (!$value is Traversable<_>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'varray<T>',
        $value,
      );
    }

    return Vec\map($value, $inner ==> $this->inner->coerceType($inner))
      |> varray($$);
  }

  <<__Override>>
  public function assertType(mixed $value): varray<T> {
    if (/* HH_FIXME[2049] */ /* HH_FIXME[4107] */ !is_varray($value)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'varray<T>',
        $value,
      );
    }

    $counter = (
      (): \Generator<int, int, void> ==> {
        for ($i = 0; true; $i++) {
          yield $i;
        }
      }
    )();

    return Vec\map_with_key(
      $value as KeyedTraversable<_, _>,
      ($k, $inner) ==> {
        $counter->next();
        $i = $counter->current();
        if ($k !== $i) {
          throw IncorrectTypeException::withValue(
            $this->getTrace(),
            'key '.$i,
            $k,
          );
        }
        return $this
          ->inner
          ->withTrace($this->getTrace()->withFrame('varray['.$i.']'))
          ->assertType($inner);
      },
    )
      |> varray($$);
  }

  <<__Override>>
  public function toString(): string {
    return 'varray<'.$this->inner->toString().'>';
  }
}
