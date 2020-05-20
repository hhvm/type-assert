/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

use namespace Facebook\TypeSpec;

use type Facebook\TypeAssert\UnsupportedTypeException;

<<__EntryPoint>>
function new_behavior(): void {
  require_once __DIR__.'/../../vendor/hh_autoload.hh';

  // It is possible to keep the backward compatible behavior by not passing a resolver.
  // @typechecker-type TypeSpec<dict<string, UserID>>
  // @runtime-type     TypeSpec<dict<string, int>>
  $without_resolver = TypeSpec\of<dict<string, UserID>>();

  echo '$without_resolver: '.$without_resolver->toString().\PHP_EOL;

  // You can opt-in to strict behavior without providing your own custom types.
  try {
    $_throws = TypeSpec\of<dict<string, UserID>>(TypeSpec\throwing_resolver());
  } catch (UnsupportedTypeException $e) {
    echo $e->getMessage().\PHP_EOL;
  }

  // Or you provide a custom resolver.
  // @typechecker-type TypeSpec<dict<string, UserID>>
  // @runtime-type     TypeSpec<dict<string, UserID>>
  $with_custom_resolver = TypeSpec\of<dict<string, UserID>>(fun('my_resolver'));

  echo '$with_custom_resolver: '.$with_custom_resolver->toString().\PHP_EOL;
}


function my_resolver<T>(TypeStructure<T> $ts): \Facebook\TypeSpec\TypeSpec<T> {
  switch ($ts['alias']) {
    case 'UserID':
      /*HH_IGNORE_ERROR[4110] Unsafe generics*/
      return MyTypeSpec\UserID();
    default:
      throw new UnsupportedTypeException($ts['alias'] as string);
  }
}
