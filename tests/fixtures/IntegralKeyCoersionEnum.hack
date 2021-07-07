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

enum IntegralKeyCoercionEnum: arraykey {
  ONE_STR = '1';
  ONE_INT = 1;
  TWO_STR = '2';
  THREE_INT = 3;
  DUPLICATE_VALUE_4 = 4;
  ANOTHER_VALUE_4 = 4;
}
