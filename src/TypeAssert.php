<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert;

use FredEmmott\TypeAssert\PrivateImpl\TypeStructureImpl;

abstract class TypeAssert {
  final public static function isString(mixed $x): string {
    if (!is_string($x)) {
      throw IncorrectTypeException::withValue('string', $x);
    }
    return $x;
  }

  final public static function isInt(mixed $x): int {
    if (!is_int($x)) {
      throw IncorrectTypeException::withValue('int', $x);
    }
    return $x;
  }

  final public static function isFloat(mixed $x): float {
    if (!is_float($x)) {
      throw IncorrectTypeException::withValue('float', $x);
    }
    return $x;
  }

  final public static function isBool(mixed $x): bool {
    if (!is_bool($x)) {
      throw IncorrectTypeException::withValue('bool', $x);
    }
    return $x;
  }

  final public static function isResource(mixed $x): resource {
    if (!is_resource($x)) {
      throw IncorrectTypeException::withValue('resource', $x);
    }
    return /* UNSAFE_EXPR */ $x;
  }

  final public static function isNum(mixed $x): num {
    if (is_int($x)) {
      return $x;
    }
    if (is_float($x)) {
      return $x;
    }
    throw IncorrectTypeException::withValue('num', $x);
  }

  final public static function isArrayKey(mixed $x): arraykey{
    if (is_int($x)) {
      return $x;
    }
    if (is_string($x)) {
      return $x;
    }
    throw IncorrectTypeException::withValue('arraykey', $x);
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
