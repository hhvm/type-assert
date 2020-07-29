/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec;

abstract class TypeSpec<+T> {
  private ?Trace $trace = null;

  abstract public function coerceType(mixed $value): T;
  abstract public function assertType(mixed $value): T;
  abstract public function toString(): string;

  public function isOptional(): bool {
    return false;
  }

  final protected function getTrace(): Trace {
    return $this->trace ?? new Trace();
  }

  final protected function withTrace(Trace $trace): TypeSpec<T> {
    $new = clone $this;
    $new->trace = $trace;
    return $new;
  }
}

function arraykey(): TypeSpec<arraykey> {
  return new __Private\ArrayKeySpec();
}

function bool(): TypeSpec<bool> {
  return new __Private\BoolSpec();
}

function classname<T>(classname<T> $what): TypeSpec<classname<T>> {
  return new __Private\ClassnameSpec($what);
}

function constmap<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<\ConstMap<Tk, Tv>> {
  return new __Private\MapSpec(\ConstMap::class, $tsk, $tsv);
}

function constset<Tv as arraykey>(TypeSpec<Tv> $tsv): TypeSpec<\ConstSet<Tv>> {
  return new __Private\SetSpec(\ConstSet::class, $tsv);
}

function constvector<Tv>(TypeSpec<Tv> $inner): TypeSpec<\ConstVector<Tv>> {
  return new __Private\VectorSpec(\ConstVector::class, $inner);
}

function darray<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<darray<Tk, Tv>> {
  return new __Private\DarraySpec($tsk, $tsv);
}

function dict<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<dict<Tk, Tv>> {
  return new __Private\DictSpec($tsk, $tsv);
}

function enum<T as arraykey>(\HH\enumname<T> $what): TypeSpec<T> {
  return new __Private\EnumSpec($what);
}

function float(): TypeSpec<float> {
  return new __Private\FloatSpec();
}

function instance_of<T>(classname<T> $what): TypeSpec<T> {
  return new __Private\InstanceOfSpec($what);
}

function int(): TypeSpec<int> {
  return new __Private\IntSpec();
}

function immmap<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<ImmMap<Tk, Tv>> {
  return new __Private\MapSpec(ImmMap::class, $tsk, $tsv);
}

function immset<Tv as arraykey>(TypeSpec<Tv> $tsv): TypeSpec<ImmSet<Tv>> {
  return new __Private\SetSpec(ImmSet::class, $tsv);
}

function immvector<Tv>(TypeSpec<Tv> $inner): TypeSpec<ImmVector<Tv>> {
  return new __Private\VectorSpec(ImmVector::class, $inner);
}

function keyset<Tk as arraykey>(TypeSpec<Tk> $inner): TypeSpec<keyset<Tk>> {
  return new __Private\KeysetSpec($inner);
}

function map<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<Map<Tk, Tv>> {
  return new __Private\MapSpec(Map::class, $tsk, $tsv);
}

function mixed(): TypeSpec<mixed> {
  return new __Private\MixedSpec();
}

function nonnull(): TypeSpec<nonnull> {
  return new __Private\NonNullSpec();
}

function null(): TypeSpec<null> {
  return new __Private\NullSpec();
}

function nullable<T>(TypeSpec<T> $inner): TypeSpec<?T> {
  return new __Private\NullableSpec($inner);
}


function num(): TypeSpec<num> {
  return new __Private\NumSpec();
}

function resource(?string $kind = null): TypeSpec<resource> {
  return new __Private\ResourceSpec($kind);
}

function set<Tv as arraykey>(TypeSpec<Tv> $tsv): TypeSpec<Set<Tv>> {
  return new __Private\SetSpec(Set::class, $tsv);
}

function string(): TypeSpec<string> {
  return new __Private\StringSpec();
}

function varray<Tv>(TypeSpec<Tv> $tsv): TypeSpec<varray<Tv>> {
  return new __Private\VarraySpec($tsv);
}

function vec<Tv>(TypeSpec<Tv> $inner): TypeSpec<vec<Tv>> {
  return new __Private\VecSpec($inner);
}

function vector<Tv>(TypeSpec<Tv> $inner): TypeSpec<Vector<Tv>> {
  return new __Private\VectorSpec(Vector::class, $inner);
}

function varray_or_darray<Tv>(
  TypeSpec<Tv> $inner,
): TypeSpec<varray_or_darray<Tv>> {
  return new __Private\VArrayOrDArraySpec($inner);
}

function of<reify T>(): TypeSpec<T> {
  return __Private\from_type_structure(
    \HH\ReifiedGenerics\get_type_structure<T>(),
  );
}
