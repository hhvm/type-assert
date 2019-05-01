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

final class VecLikeArraySpec<T> extends TypeSpec<array<T>> {
  public function __construct(private TypeSpec<T> $inner) {
  }

  <<__Override>>
  public function coerceType(mixed $value): array<T> {
    if (!$value instanceof Traversable) {
      throw
        TypeCoercionException::withValue($this->getTrace(), 'array<T>', $value);
    }

    return Vec\map($value, $inner ==> $this->inner->coerceType($inner))
      |> \array_values($$);
  }

  <<__Override>>
  public function assertType(mixed $value): array<T> {
    if (!\is_array($value)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'array<T>',
        $value,
      );
    }

    $counter = (
      function(): \Generator<int, int, void> {
        for ($i = 0; true; $i++) {
          yield $i;
        }
      }
    )();

    return Vec\map_with_key(
      $value,
      ($k, $inner) ==> {
        $counter->next();
        $i = $counter->current();
        if ($k !== $i) {
          throw
            IncorrectTypeException::withValue($this->getTrace(), 'key '.$i, $k);
        }
        return $this
          ->inner
          ->withTrace($this->getTrace()->withFrame('array['.$i.']'))
          ->assertType($inner);
      },
    )
      |> \array_values($$);
  }
}
