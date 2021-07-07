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
use namespace HH\Lib\{Str, Vec};

newtype BogusTuple = (mixed, mixed);

final class TupleSpec extends TypeSpec<BogusTuple> {
  public function __construct(private vec<TypeSpec<mixed>> $inners) {
  }

  <<__Override>>
  public function coerceType(mixed $value): BogusTuple {
    if (!$value is vec<_>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'tuple',
        $value,
      );
    }
    $values = vec($value);

    $count = \count($values);
    if ($count !== \count($this->inners)) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        \count($this->inners).'-tuple',
        $value,
      );
    }

    $out = vec[];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]
        ->withTrace($this->getTrace()->withFrame('tuple['.$i.']'))
        ->coerceType($values[$i]);
    }
    return self::vecToTupleUNSAFE($out);
  }

  <<__Override>>
  public function assertType(mixed $value): BogusTuple {
    if (!$value is vec<_>) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'tuple',
        $value,
      );
    }
    $values = $value;

    $count = \count($values);
    if ($count !== \count($this->inners)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        \count($this->inners).'-tuple',
        $value,
      );
    }

    $out = vec[];
    for ($i = 0; $i < $count; ++$i) {
      $out[] = $this->inners[$i]
        ->withTrace($this->getTrace()->withFrame('tuple['.$i.']'))
        ->assertType($values[$i]);
    }
    return self::vecToTupleUNSAFE($out);
  }

  private static function vecToTupleUNSAFE(vec<mixed> $tuple): BogusTuple {
    /* HH_IGNORE_ERROR[4110] Depends on runtime representation of tuple being vec */
    return $tuple;
  }

  <<__Override>>
  public function toString(): string {
    return Vec\map($this->inners, $it ==> $it->toString())
      |> Str\join($$, ', ')
      |> '('.$$.')';
  }
}
