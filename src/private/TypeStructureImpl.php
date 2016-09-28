<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert\Private;

use \FredEmmott\TypeAssert\IncorrectTypeException;
use \FredEmmott\TypeAssert\TypeAssert;
use \FredEmmott\TypeAssert\UnsupportedTypeException;
use \TypeStructureKind as Kind;

abstract final class TypeStructureImpl {
  final public static function assertMatchesTypeStructure<T>(
    TypeStructure<T> $ts,
    mixed $value,
  ): void {
    if ($value === null && Shapes::idx($ts, 'nullable')) {
      return;
    }

    switch ($ts['kind']) {
      case Kind::OF_VOID:
        throw new UnsupportedTypeException('OF_VOID');
      case Kind::OF_INT:
        TypeAssert::isInt($value);
        return;
      case Kind::OF_BOOL:
        TypeAssert::isBool($value);
        return;
      case Kind::OF_FLOAT:
        TypeAssert::isFloat($value);
        return;
      case Kind::OF_STRING:
        TypeAssert::isString($value);
        return;
      case Kind::OF_RESOURCE:
        TypeAssert::isResource($value);
        return;
      case Kind::OF_NUM:
        TypeAssert::isNum($value);
        return;
      case Kind::OF_ARRAYKEY:
        TypeAssert::isArrayKey($value);
        return;
      case Kind::OF_NORETURN:
        throw new UnsupportedTypeException('OF_NORETURN');
      case Kind::OF_MIXED:
        return;
      case Kind::OF_TUPLE:
        if (!is_array($value)) {
          throw IncorrectTypeException::withValue('tuple', $value);
        }
        $subtypes = TypeAssert::isNotNull($ts['elem_types']);
        if (count($value) !== count($subtypes)) {
          throw new IncorrectTypeException(
            'tuple with '.count($subtypes).' elements',
            'array with '.count($value).' elements',
          );
        }
        for ($i = 0; $i < count($subtypes); ++$i) {
          self::assertMatchesTypeStructure(
            $subtypes[$i],
            $value[$i],
          );
        }
        return;
      case Kind::OF_FUNCTION:
        throw new UnsupportedTypeException('OF_FUNCTION');
      case Kind::OF_ARRAY:
        if (!is_array($value)) {
          throw IncorrectTypeException::withValue('array', $value);
        }
        $generics = TypeAssert::isNotNull($ts['generic_types']);
        $count = count($generics);
        if ($count === 0) {
          // not valid strict, but valid mixed
          return;
        }
        if ($count === 1) {
          self::assertValueTypes($generics[0], $value);
          return;
        }
        if ($count === 2) {
          self::assertKeyAndValueTypes(
            $generics[0],
            $generics[1],
            $value,
          );
          return;
        }
        throw new UnsupportedTypeException('OF_ARRAY with > 2 generics');
      case Kind::OF_GENERIC:
        throw new UnsupportedTypeException('OF_GENERIC');
      case Kind::OF_SHAPE:
        // FIXME
      case Kind::OF_CLASS:
      case Kind::OF_INTERFACE:
        $class = TypeAssert::isNotNull($ts['classname']);

        if (is_a($class, KeyedTraversable::class, /* strings = */ true)) {
          list($keys_ts, $values_ts) = TypeAssert::isNotNull(
            $ts['generic_types'],
          );
          self::assertKeyAndValueTypes(
            $keys_ts,
            $values_ts,
            /* HH_IGNORE_ERROR[4110] */ $value,
          );
        } else if (
          is_a($class, Traversable::class, /* strings = */ true)
        ) {
          list($values_ts) = TypeAssert::isNotNull(
            $ts['generic_types'],
          );
          self::assertValueTypes(
            $values_ts,
            /* HH_IGNORE_ERROR[4110] */ $value,
          );
        }

        TypeAssert::isInstanceOf(
          TypeAssert::isNotNull($ts['classname']),
          $value,
        );
        return;
      case Kind::OF_TRAIT:
        throw new UnsupportedTypeException('OF_UNRESOLVED');
      case Kind::OF_ENUM:
        $enum = TypeAssert::isNotNull($ts['classname']);
        $enum::assert($value);
        return;
      case Kind::OF_UNRESOLVED:
        throw new UnsupportedTypeException('OF_UNRESOLVED');
    }
    invariant_violation(
      'Unsupported kind: %s',
      Kind::getNames()[$ts['kind']] ?? var_export($ts['kind'], true),
    );
  }

  public static function assertKeyAndValueTypes<Tk, Tv>(
    TypeStructure<Tk> $key_ts,
    TypeStructure<Tv> $value_ts,
    KeyedTraversable<mixed, mixed> $traversable,
  ): void {
    foreach ($traversable as $key => $value) {
      self::assertMatchesTypeStructure($key_ts, $key);
      self::assertMatchesTypeStructure($value_ts, $value);
    }
  }

  public static function assertValueTypes<Tk, Tv>(
    TypeStructure<Tv> $value_ts,
    KeyedTraversable<mixed, mixed> $traversable,
  ): void {
    foreach ($traversable as $value) {
      self::assertMatchesTypeStructure($value_ts, $value);
    }
  }
}
