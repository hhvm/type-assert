<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert;

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

  final public static function isNotNull<T>(?T $x): T {
    if ($x === null) {
      throw new IncorrectTypeException('not-null', 'null');
    }
    return $x;
  }
}
