<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\{
  IncorrectTypeException,
  TypeCoercionException
};
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\Dict;

final class DictSpec<Tk as arraykey, Tv>
  implements TypeSpec<dict<Tk, Tv>> {

  public function __construct(
    private TypeSpec<Tk> $tsk,
    private TypeSpec<Tv> $tsv,
  ) {
  }

  public function coerceType(mixed $value): dict<Tk, Tv> {
    if (!$value instanceof KeyedTraversable) {
      throw TypeCoercionException::withValue('dict<Tk, Tv>', $value);
    }

    return Dict\pull_with_key(
      $value,
      ($_k, $v) ==> $this->tsv->coerceType($v),
      ($k, $_v) ==> $this->tsk->coerceType($k),
    );
  }

  public function assertType(mixed $value): dict<Tk, Tv> {
    if (!is_dict($value)) {
      throw TypeCoercionException::withValue('dict<Tk, Tv>', $value);
    }

    return Dict\pull_with_key(
      $value,
      ($_k, $v) ==> $this->tsv->assertType($v),
      ($k, $_v) ==> $this->tsk->assertType($k),
    );
  }
}
