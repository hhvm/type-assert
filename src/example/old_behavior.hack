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

use type Facebook\TypeAssert\IncorrectTypeException;

<<__EntryPoint>>
function old_behavior(): void {
  require_once __DIR__.'/../../vendor/hh_autoload.hh';

  // @type TypeSpec<dict<string, int>>
  $_1 = TypeSpec\dict(TypeSpec\string(), TypeSpec\int());

  // @type TypeSpec<dict<string, UserID>>
  $with_manual_typespec = TypeSpec\dict(TypeSpec\string(), MyTypeSpec\UserID());
  echo '$with_manual_typespec: '.$with_manual_typespec->toString().\PHP_EOL;


  // @typechecker-type TypeSpec<dict<string, UserID>>
  // @runtime-type     TypeSpec<dict<string, int>>
  $with_typespec_of = TypeSpec\of<dict<string, UserID>>();
  echo '$with_typespec_of:     '.$with_typespec_of->toString().\PHP_EOL;


  // @typechecker-type UserID
  // @runtime-type     int (not validated)
  $user_id = $with_typespec_of->assertType(dict['string' => 1])['string'];

  // TypeAssert collapsed UserID to int and my invariance on UserID is silently violated.
  echo "Is my \$user_id a UserID?\n";
  \var_dump(\is_user_id($user_id as int));

  try {
    $_throws = $with_manual_typespec->assertType(dict['string' => 1]);
  } catch (IncorrectTypeException $e) {
    echo "\nThe manual typespec validated my invariant\n";
    echo $e->getMessage();
  }
}
