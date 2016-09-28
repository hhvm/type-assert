<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert;

use \TypeStructureKind as Kind;

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
    switch ($ts['kind']) {
      case Kind::OF_VOID:
        throw new UnsupportedTypeException('OF_VOID');
      case Kind::OF_INT:
        return /* HH_IGNORE_ERROR[4110] */ self::isInt($value);
      case Kind::OF_BOOL:
        return /* HH_IGNORE_ERROR[4110] */ self::isBool($value);
      case Kind::OF_FLOAT:
        return /* HH_IGNORE_ERROR[4110] */ self::isFloat($value);
      case Kind::OF_STRING:
        return /* HH_IGNORE_ERROR[4110] */ self::isString($value);
      case Kind::OF_RESOURCE:
        return /* HH_IGNORE_ERROR[4110] */ self::isResource($value);
      case Kind::OF_NUM:
        return /* HH_IGNORE_ERROR[4110] */ self::isNum($value);
      case Kind::OF_ARRAYKEY:
        return /* HH_IGNORE_ERROR[4110] */ self::isArrayKey($value);
      case Kind::OF_NORETURN:
        throw new UnsupportedTypeException('OF_NORETURN');
      case Kind::OF_MIXED:
        return /* HH_IGNORE_ERROR[4110] */ $value;
      case Kind::OF_TUPLE:
        // FIXME
      case Kind::OF_FUNCTION:
        throw new UnsupportedTypeException('OF_FUNCTION');
      case Kind::OF_ARRAY:
        // FIXME
      case Kind::OF_GENERIC:
        throw new UnsupportedTypeException('OF_GENERIC');
      case Kind::OF_SHAPE:
        // FIXME
      case Kind::OF_CLASS:
      case Kind::OF_INTERFACE:
        // FIXME: validate classes
        $class = self::isNotNull($ts['classname']);
        return /* HH_IGNORE_ERROR[4110] */ self::isInstanceOf(
          self::isNotNull($ts['classname']),
          $value,
        );
      case Kind::OF_TRAIT:
        throw new UnsupportedTypeException('OF_UNRESOLVED');
      case Kind::OF_ENUM:
        // FIXME
      case Kind::OF_UNRESOLVED:
        throw new UnsupportedTypeException('OF_UNRESOLVED');
    }
  }
}
