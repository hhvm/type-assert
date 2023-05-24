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
    invariant(
      $stringish is \StringishObject,
      'Expected Stringish to be either a string or a StringishObject, got %s',
      \get_class($stringish) ?: \gettype($stringish),
    );
    \trigger_error(
      'Stringish is being deprecated. '.
      'Passing an object that implements __toString to '.
      $caller.
      '() may not work in a future release.',
      \E_USER_DEPRECATED,
    );
    return $stringish->__toString();
  }
}
