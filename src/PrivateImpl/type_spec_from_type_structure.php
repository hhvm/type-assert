<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert\PrivateImpl;

use type Facebook\TypeAssert\{
  TypeAssert,
  TypeSpec,
  UnsupportedTypeException
};
use namespace Facebook\TypeAssert\TypeSpec;
use namespace HH\Lib\{C, Dict, Vec};

function type_spec_from_type_structure<T>(
  TypeStructure<T> $ts
): TypeSpec<T> {
  if ($ts['nullable'] ?? false) {
    $ts['nullable'] = false;
      /* HH_IGNORE_ERROR[4110] */
    return new NullableSpec(type_spec_from_type_structure($ts));
  }

  /* HH_IGNORE_ERROR[4022] exhaustive + default */
  switch ($ts['kind']) {
    case TypeStructureKind::OF_VOID:
      throw new UnsupportedTypeException('OF_VOID');
    case TypeStructureKind::OF_INT:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\int();
    case TypeStructureKind::OF_BOOL:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\bool();
    case TypeStructureKind::OF_FLOAT:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\float();
    case TypeStructureKind::OF_STRING:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\string();
    case TypeStructureKind::OF_RESOURCE:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\resource();
    case TypeStructureKind::OF_NUM:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\num();
    case TypeStructureKind::OF_ARRAYKEY:
      /* HH_IGNORE_ERROR[4110] */
      return TypeSpec\arraykey();
    case TypeStructureKind::OF_NORETURN:
      throw new UnsupportedTypeException('OF_NORETURN');
    case TypeStructureKind::OF_MIXED:
      /* HH_IGNORE_ERROR[4110] */
      return new MixedSpec();
    case TypeStructureKind::OF_TUPLE:
      /* HH_IGNORE_ERROR[4110] */
      return new TupleSpec(
        Vec\map(
          TypeAssert::isNotNull($ts['elem_types']),
          $elem ==> type_spec_from_type_structure($elem),
        ),
      );
    case TypeStructureKind::OF_FUNCTION:
      throw new UnsupportedTypeException('OF_FUNCTION');
    case TypeStructureKind::OF_ARRAY:
      $generics = TypeAssert::isNotNull($ts['generic_types']);
      switch (C\count($generics)) {
        case 0:
          /* HH_IGNORE_ERROR[4110] */
          return new UntypedArraySpec();
        case 1:
          /* HH_IGNORE_ERROR[4110] */
          return new VecLikeArraySpec(
            type_spec_from_type_structure($generics[0]),
          );
        case 2:
          /* HH_IGNORE_ERROR[4110] */
          return new DictLikeArraySpec(
            type_spec_from_type_structure($generics[0]),
            type_spec_from_type_structure($generics[1]),
          );
        default:
          invariant_violation('OF_ARRAY with > 2 generics');
      }
    case TypeStructureKind::OF_DICT:
      $generics = TypeAssert::isNotNull($ts['generic_types']);
      invariant(
        C\count($generics) === 2,
        'dicts must have 2 generics',
      );
      /* HH_IGNORE_ERROR[4110] */
      return new DictSpec(
        type_spec_from_type_structure($generics[0]),
        type_spec_from_type_structure($generics[1]),
      );
    case TypeStructureKind::OF_KEYSET:
      $generics = TypeAssert::isNotNull($ts['generic_types']);
      invariant(
        C\count($generics) === 1,
        'keysets must have 1 generic',
      );
      /* HH_IGNORE_ERROR[4110] */
      return new KeysetSpec(
        type_spec_from_type_structure($generics[0]),
      );
    case TypeStructureKind::OF_VEC:
      $generics = TypeAssert::isNotNull($ts['generic_types']);
      invariant(
        C\count($generics) === 1,
        'vecs must have 1 generic',
      );
      /* HH_IGNORE_ERROR[4110] */
      return new VecSpec(
        type_spec_from_type_structure($generics[0]),
      );
    case TypeStructureKind::OF_GENERIC:
      throw new UnsupportedTypeException('OF_GENERIC');
    case TypeStructureKind::OF_SHAPE:
      $fields = TypeAssert::isNotNull($ts['fields']);
      /* HH_IGNORE_ERROR[4110] */
      return new ShapeSpec(
        Dict\pull_with_key(
          $fields,
          ($_k, $field_ts) ==> type_spec_from_type_structure($field_ts),
          ($k, $_v) ==> $k,
        ),
      );
    case TypeStructureKind::OF_CLASS:
    case TypeStructureKind::OF_INTERFACE:
      $classname = TypeAssert::isNotNull($ts['classname']);
      switch($classname) {
        case Vector::class:
        case ImmVector::class:
        case \ConstVector::class:
          return new VectorSpec(
            $classname,
            type_spec_from_type_structure(
              TypeAssert::isNotNull($ts['generic_types'] ?? null)[0],
            ),
          );
        case Map::class:
        case ImmMap::class:
        case \ConstMap::class:
          return new MapSpec(
            $classname,
            type_spec_from_type_structure(
              TypeAssert::isNotNull($ts['generic_types'] ?? null)[0],
            ),
            type_spec_from_type_structure(
              TypeAssert::isNotNull($ts['generic_types'] ?? null)[1],
            ),
          );
        case Set::class:
        case ImmSet::class:
        case \ConstSet::class:
          return new SetSpec(
            $classname,
            type_spec_from_type_structure(
              TypeAssert::isNotNull($ts['generic_types'] ?? null)[0],
            ),
          );
        default:
          return new InstanceOfSpec(
            TypeAssert::isNotNull($ts['classname']),
          );
      }
    case TypeStructureKind::OF_TRAIT:
      throw new UnsupportedTypeException('OF_TRAIT');
    case TypeStructureKind::OF_ENUM:
      $enum = TypeAssert::isNotNull($ts['classname']);
      /* HH_IGNORE_ERROR[4110] */
      return new EnumSpec($enum);
    case TypeStructureKind::OF_UNRESOLVED:
      throw new UnsupportedTypeException('OF_UNRESOLVED');
    default:
      $name = TypeStructureKind::getNames()[$ts['kind']] ??
        var_export($ts['kind'], true);
      throw new UnsupportedTypeException($name);
  }
}
