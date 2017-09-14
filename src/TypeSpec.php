<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeSpec;

abstract class TypeSpec<+T> {
  private ?__Private\Trace $trace = null;

  abstract public function coerceType(mixed $value): T;
  abstract public function assertType(mixed $value): T;

  final protected function getTrace(): __Private\Trace {
    return $this->trace ?? new __Private\Trace();
  }

  final protected function withTrace(__Private\Trace $trace): TypeSpec<T> {
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

function dict<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<dict<Tk, Tv>> {
  return new __Private\DictSpec($tsk, $tsv);
}

function dict_like_array<Tk as arraykey, Tv>(
  TypeSpec<Tk> $tsk,
  TypeSpec<Tv> $tsv,
): TypeSpec<array<Tk, Tv>> {
  return new __Private\DictLikeArraySpec($tsk, $tsv);
}

function enum<Tinner, T as /* HH_IGNORE_ERROR[2053] */ \HH\BuiltinEnum<Tinner>>(
  classname<T> $what,
): TypeSpec<T> {
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

/* HH_IGNORE_ERROR[4045] untyped array */
function untyped_array(): TypeSpec<array> {
  return new __Private\UntypedArraySpec();
}

function vec_like_array<Tv>(TypeSpec<Tv> $tsv): TypeSpec<array<Tv>> {
  return new __Private\VecLikeArraySpec($tsv);
}


function vec<Tv>(TypeSpec<Tv> $inner): TypeSpec<vec<Tv>> {
  return new __Private\VecSpec($inner);
}

function vector<Tv>(TypeSpec<Tv> $inner): TypeSpec<Vector<Tv>> {
  return new __Private\VectorSpec(Vector::class, $inner);
}
