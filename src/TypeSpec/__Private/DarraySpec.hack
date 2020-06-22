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

use namespace HH\Lib\{Dict, Str};

final class DarraySpec<Tk as arraykey, Tv>
  extends TypeSpec<darray<Tk, Tv>> {

  public function __construct(
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
  }

  <<__Override>>
  public function coerceType(mixed $value): darray<Tk, Tv> {
    if (!$value is KeyedTraversable<_, _>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'darray<Tk, Tv>',
        $value,
      );
    }

    $kt = $this->getTrace()->withFrame('darray<Tk, _>');
    $vt = $this->getTrace()->withFrame('darray<_, Tv>');

    return Dict\pull_with_key(
      $value,
      ($_k, $v) ==> $this->tsv->withTrace($vt)->coerceType($v),
      ($k, $_v) ==> $this->tsk->withTrace($kt)->coerceType($k),
    ) |> darray($$);
  }

  <<__Override>>
  public function assertType(mixed $value): darray<Tk, Tv> {
    if (/* HH_FIXME[2049] */ /* HH_FIXME[4107] */ !is_darray($value)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->toString(),
        $value,
      );
    }

    $kt = $this->getTrace()->withFrame('darray<Tk, _>');
    $vt = $this->getTrace()->withFrame('darray<_, Tv>');

    return Dict\pull_with_key(
      $value as KeyedTraversable<_, _>,
      ($_k, $v) ==> $this->tsv->withTrace($vt)->assertType($v),
      ($k, $_v) ==> $this->tsk->withTrace($kt)->assertType($k),
    )
      |> darray($$);
  }

  <<__Override>>
  public function toString(): string {
    return Str\format(
      'darray<%s, %s>',
      $this->tsk->toString(),
      $this->tsv->toString(),
    );
  }
}
