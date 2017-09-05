<?hh // strict
/*
 * Copyright (c) 2016, Fred Emmott
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

use namespace Facebook\TypeAssert\PrivateImpl\TypeSpec;

function string(mixed $x): string {
  return TypeSpec\string()->assertType($x);
}

function int(mixed $x): int {
  return TypeSpec\int()->assertType($x);
}

function float(mixed $x): float {
  return TypeSpec\float()->assertType($x);
}

function bool(mixed $x): bool {
  return TypeSpec\bool()->assertType($x);
}

function resource(mixed $x): resource {
  return TypeSpec\resource()->assertType($x);
}

function num(mixed $x): num {
  return TypeSpec\num()->assertType($x);
}

function arraykey(mixed $x): arraykey {
  return TypeSpec\arraykey()->assertType($x);
}

function not_null<T>(?T $x): T {
  if ($x === null) {
    throw new IncorrectTypeException('not-null', 'null');
  }
  return $x;
}

function instance_of<T>(
  classname<T> $type,
  mixed $what,
): T {
  return TypeSpec\instance_of($type)->assertType($what);
}

function classname_of<T>(
  classname<T> $expected,
  string $what,
): classname<T> {
  return TypeSpec\classname($expected)->assertType($what);
}

function matches_type_structure<T>(
  TypeStructure<T> $ts,
  mixed $value,
): T {
  return TypeSpec\from_type_structure($ts)->assertType($value);
}
