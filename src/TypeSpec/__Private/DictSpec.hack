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

final class DictSpec<Tk as arraykey, Tv> extends TypeSpec<dict<Tk, Tv>> {

  public function __construct(
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
  }

  <<__Override>>
  public function coerceType(mixed $value): dict<Tk, Tv> {
    if (!$value is KeyedTraversable<_, _>) {
      throw TypeCoercionException::withValue(
        $this->getTrace(),
        'dict<Tk, Tv>',
        $value,
      );
    }

    $kt = $this->getTrace()->withFrame('dict<Tk, _>');
    $vt = $this->getTrace()->withFrame('dict<_, Tv>');

    return Dict\pull_with_key(
      $value,
      ($_k, $v) ==> $this->tsv->withTrace($vt)->coerceType($v),
      ($k, $_v) ==> $this->tsk->withTrace($kt)->coerceType($k),
    );
  }

  <<__Override>>
  public function assertType(mixed $value): dict<Tk, Tv> {
    if (!($value is dict<_, _>)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        'dict<Tk, Tv>',
        $value,
      );
    }

    $kt = $this->getTrace()->withFrame('dict<Tk, _>');
    $vt = $this->getTrace()->withFrame('dict<_, Tv>');

    return Dict\pull_with_key(
      $value,
      ($_k, $v) ==> $this->tsv->withTrace($vt)->assertType($v),
      ($k, $_v) ==> $this->tsk->withTrace($kt)->assertType($k),
    );
  }

  <<__Override>>
  public function toString(): string {
    return Str\format(
      '%s<%s, %s>',
      dict::class,
      $this->tsk->toString(),
      $this->tsv->toString(),
    );
  }
}
