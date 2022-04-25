/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeAssert\TestFixtures;

/**
 * This enum exists to make `IntishStringEnum::assert(1)` return `string(1) "1"`.
 * `EnumSpec->assertType(): T` may return a different type under these conditions.
 */
enum IntishStringEnum: string {
  ONE = '1';
}
