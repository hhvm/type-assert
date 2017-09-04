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

use Facebook\TypeAssert\PrivateImpl\TypeStructureImpl;

abstract class TypeAssert {
  final public static function isString(mixed $x): string {
    return TypeSpec\string()->assertType($x);
  }

  final public static function isInt(mixed $x): int {
    return TypeSpec\int()->assertType($x);
  }

  final public static function isFloat(mixed $x): float {
    return TypeSpec\float()->assertType($x);
  }

  final public static function isBool(mixed $x): bool {
    return TypeSpec\bool()->assertType($x);
  }

  final public static function isResource(mixed $x): resource {
    if (!is_resource($x)) {
      throw IncorrectTypeException::withValue('resource', $x);
    }
    return /* UNSAFE_EXPR */ $x;
  }

  final public static function isNum(mixed $x): num {
    return TypeSpec\num()->assertType($x);
  }

  final public static function isArrayKey(mixed $x): arraykey {
    return TypeSpec\arraykey()->assertType($x);
  }

  final public static function isNotNull<T>(?T $x): T {
    if ($x === null) {
      throw new IncorrectTypeException('not-null', 'null');
    }
    return $x;
  }

  final public static function isInstanceOf<T>(
    classname<T> $type,
    mixed $what,
  ): T {
    /* HH_FIXME[4162] over-aggressive instanceof check */
    if ($what instanceof $type) {
      return $what;
    }
    throw IncorrectTypeException::withValue($type, $what);
  }

  final public static function isClassnameOf<T>(
    classname<T> $expected,
    string $what,
  ): classname<T> {
    if (is_a($what, $expected, /* strings = */ true)) {
      /* HH_IGNORE_ERROR[4110] doesn't understand is_a */
      return $what;
    }
    throw IncorrectTypeException::withType($expected, $what);
  }

  final public static function matchesTypeStructure<T>(
    TypeStructure<T> $ts,
    mixed $value,
  ): T {
    TypeStructureImpl::assertMatchesTypeStructure($ts, $value);
    return /* HH_IGNORE_ERROR[4110] */ $value;
  }
}
