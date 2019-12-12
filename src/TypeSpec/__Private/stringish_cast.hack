/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */
namespace Facebook\TypeSpec\__Private;

function stringish_cast(\Stringish $stringish, string $caller): string {
  if ($stringish is string) {
    return $stringish;
  } else if (\HH\is_fun($stringish)) {
    return \HH\fun_get_function($stringish);
  } else {
    \trigger_error(
      'Stringish is being deprecated. '.
      'Passing an object that implements __toString to '.
      $caller.
      '() may not work in a future release.',
      \E_USER_DEPRECATED,
    );
    /*HH_FIXME[4128] stringish_cast() can't be used in the future.*/
    return $stringish->__toString();
  }
}
