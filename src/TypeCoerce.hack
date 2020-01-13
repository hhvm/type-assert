/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeCoerce;

use namespace Facebook\TypeSpec;

function string(mixed $x): string {
  return TypeSpec\string()->coerceType($x);
}

function int(mixed $x): int {
  return TypeSpec\int()->coerceType($x);
}

function float(mixed $x): float {
  return TypeSpec\float()->coerceType($x);
}

function bool(mixed $x): bool {
  return TypeSpec\bool()->coerceType($x);
}

function resource(mixed $x): resource {
  return TypeSpec\resource()->coerceType($x);
}

function num(mixed $x): num {
  return TypeSpec\num()->coerceType($x);
}

function arraykey(mixed $x): arraykey {
  return TypeSpec\arraykey()->coerceType($x);
}

function match_type_structure<T>(TypeStructure<T> $ts, mixed $value): T {
  return TypeSpec\__Private\from_type_structure($ts)->coerceType($value);
}

function match<reify T>(mixed $value): T {
  return TypeSpec\of<T>()->coerceType($value);
}
