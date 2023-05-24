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

use type Facebook\TypeSpec\TypeSpec;

/**
 * EXTREMELY UNSAFE!!!
 *
 * Rebinds the `<T>` of `$ts` to `nothing`.
 * This means you'll be able to pass this TypeSpec for any other TypeSpec.
 * This kind of unsafe trickery is needed when dynamically constructing
 * a TypeSpec for a dynamic `T`, such as in `from_type_structure<T>()`.
 * There is nothing you can do to prove to Hack that the checks you did
 * on the TypeStructure ensure your `T` and its `T` are compatible.
 */
function as_type_spec_UNSAFE(TypeSpec<mixed> $ts): TypeSpec<nothing> {
  return \HH\FIXME\UNSAFE_CAST<TypeSpec<mixed>, TypeSpec<nothing>>($ts);
}
