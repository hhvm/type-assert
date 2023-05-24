/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\UnsupportedTypeException;
use type Facebook\TypeSpec\TypeSpec;
use namespace HH\Lib\{C, Dict, Vec};
use namespace Facebook\{TypeAssert, TypeSpec};

function from_type_structure<T>(TypeStructure<T> $ts): TypeSpec<T> {
  if ($ts['optional_shape_field'] ?? false) {
    $ts['optional_shape_field'] = false;
    return new OptionalSpec(from_type_structure(
      \HH\FIXME\UNSAFE_CAST<shape(...), TypeStructure<T>>($ts),
    ));
  }
  if ($ts['nullable'] ?? false) {
    $ts['nullable'] = false;
    return new NullableSpec(from_type_structure(
      \HH\FIXME\UNSAFE_CAST<shape(...), TypeStructure<T>>($ts),
    ))
      |> as_type_spec_UNSAFE($$);
  }

  try {
    switch ($ts['kind']) {
      case TypeStructureKind::OF_NOTHING:
        throw new UnsupportedTypeException('OF_NOTHING');
      case TypeStructureKind::OF_VEC_OR_DICT:
        throw new UnsupportedTypeException('OF_VEC_OR_DICT');
      case TypeStructureKind::OF_XHP:
        throw new UnsupportedTypeException('OF_XHP');
      case TypeStructureKind::OF_VOID:
        throw new UnsupportedTypeException('OF_VOID');
      case TypeStructureKind::OF_INT:
        return TypeSpec\int() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_BOOL:
        return TypeSpec\bool() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_FLOAT:
        return TypeSpec\float() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_STRING:
        return TypeSpec\string() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_RESOURCE:
        return TypeSpec\resource() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_NUM:
        return TypeSpec\num() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_ARRAYKEY:
        return TypeSpec\arraykey() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_NORETURN:
        throw new UnsupportedTypeException('OF_NORETURN');
      case TypeStructureKind::OF_DYNAMIC:
      case TypeStructureKind::OF_MIXED:
        return new MixedSpec() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_TUPLE:
        return new TupleSpec(
          Vec\map(
            TypeAssert\not_null($ts['elem_types']),
            from_type_structure<>,
          ),
        )
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_FUNCTION:
        throw new UnsupportedTypeException('OF_FUNCTION');
      case TypeStructureKind::OF_ARRAY:
        throw new UnsupportedTypeException('OF_ARRAY');
      case TypeStructureKind::OF_VARRAY:
        $generics = $ts['generic_types'] as nonnull;
        invariant(
          C\count($generics) === 1,
          'got varray with multiple generics',
        );
        // When given a legacy varray<_> type, we can return a vec<_> spec instead.
        return TypeSpec\vec(from_type_structure($generics[0]))
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_DARRAY:
        $generics = $ts['generic_types'] as nonnull;
        invariant(
          C\count($generics) === 2,
          'darrays must have exactly 2 generics',
        );
        // When given a legacy darray<_, _> type, we can return a dict<_, _> spec instead.
        return TypeSpec\dict(
          from_type_structure($generics[0]),
          from_type_structure($generics[1]),
        )
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_VARRAY_OR_DARRAY:
        throw new UnsupportedTypeException('OF_VARRAY_OR_DARRAY');
      case TypeStructureKind::OF_DICT:
        $generics = TypeAssert\not_null($ts['generic_types']);
        invariant(C\count($generics) === 2, 'dicts must have 2 generics');
        return TypeSpec\dict(
          from_type_structure($generics[0]),
          from_type_structure($generics[1]),
        )
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_KEYSET:
        $generics = TypeAssert\not_null($ts['generic_types']);
        invariant(C\count($generics) === 1, 'keysets must have 1 generic');
        return TypeSpec\keyset(from_type_structure($generics[0]))
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_VEC:
        $generics = TypeAssert\not_null($ts['generic_types']);
        invariant(C\count($generics) === 1, 'vecs must have 1 generic');
        return TypeSpec\vec(from_type_structure($generics[0]))
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_GENERIC:
        throw new UnsupportedTypeException('OF_GENERIC');
      case TypeStructureKind::OF_SHAPE:
        $fields = TypeAssert\not_null($ts['fields']);
        return new ShapeSpec(
          Dict\pull_with_key(
            $fields,
            ($_k, $field_ts) ==> from_type_structure($field_ts),
            ($k, $_v) ==> $k,
          ),
          ($ts['allows_unknown_fields'] ?? false)
            ? UnknownFieldsMode::ALLOW
            : UnknownFieldsMode::DENY,
        )
          |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_CLASS:
      case TypeStructureKind::OF_INTERFACE:
        $classname = TypeAssert\not_null($ts['classname']);
        switch ($classname) {
          case Vector::class:
          case ImmVector::class:
          case \ConstVector::class:
            return new VectorSpec(
              \HH\FIXME\UNSAFE_CAST<classname<T>, classname<\ConstVector<_>>>(
                $classname,
              ),
              from_type_structure(
                TypeAssert\not_null($ts['generic_types'] ?? null)[0],
              ),
            )
              |> as_type_spec_UNSAFE($$);
          case Map::class:
          case ImmMap::class:
          case \ConstMap::class:
            return new MapSpec(
              \HH\FIXME\UNSAFE_CAST<classname<T>, classname<\ConstMap<_, _>>>(
                $classname,
              ),
              from_type_structure(
                TypeAssert\not_null($ts['generic_types'] ?? null)[0],
              ),
              from_type_structure(
                TypeAssert\not_null($ts['generic_types'] ?? null)[1],
              ),
            )
              |> as_type_spec_UNSAFE($$);
          case Set::class:
          case ImmSet::class:
          case \ConstSet::class:
            return new SetSpec(
              \HH\FIXME\UNSAFE_CAST<classname<T>, classname<\ConstSet<_>>>(
                $classname,
              ),
              from_type_structure(
                TypeAssert\not_null($ts['generic_types'] ?? null)[0],
              ),
            )
              |> as_type_spec_UNSAFE($$);
          default:
            if (
              \is_a(
                $classname,
                KeyedTraversable::class,
                /* strings = */ true,
              )
            ) {
              return new KeyedTraversableSpec(
                \HH\FIXME\UNSAFE_CAST<
                  classname<T>,
                  classname<KeyedTraversable<_, _>>,
                >($classname),
                from_type_structure(
                  TypeAssert\not_null($ts['generic_types'] ?? null)[0],
                ),
                from_type_structure(
                  TypeAssert\not_null($ts['generic_types'] ?? null)[1],
                ),
              )
                |> as_type_spec_UNSAFE($$);
            }
            if (\is_a($classname, Traversable::class, /* strings = */ true)) {
              return new TraversableSpec(
                \HH\FIXME\UNSAFE_CAST<classname<T>, classname<Traversable<_>>>(
                  $classname,
                ),
                from_type_structure(
                  TypeAssert\not_null($ts['generic_types'] ?? null)[0],
                ),
              )
                |> as_type_spec_UNSAFE($$);
            }
            return new InstanceOfSpec($classname);
        }
      case TypeStructureKind::OF_TRAIT:
        throw new UnsupportedTypeException('OF_TRAIT');
      case TypeStructureKind::OF_ENUM:
        $enum = TypeAssert\not_null($ts['classname'])
          |> \HH\FIXME\UNSAFE_CAST<classname<T>, \HH\enumname<arraykey>>($$);
        return new EnumSpec($enum) |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_NULL:
        return new NullSpec() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_NONNULL:
        return new NonNullSpec() |> as_type_spec_UNSAFE($$);
      case TypeStructureKind::OF_UNRESOLVED:
        throw new UnsupportedTypeException('OF_UNRESOLVED');
    }
  } catch (\RuntimeException $_switch_statement_was_not_exhaustive) {
    $name = TypeStructureKind::getNames()[$ts['kind']] ??
      \var_export($ts['kind'], true);
    throw new UnsupportedTypeException($name);
  }
}
