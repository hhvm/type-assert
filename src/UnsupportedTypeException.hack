/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeAssert;

final class UnsupportedTypeException extends \Exception {
  public function __construct(string $type) {
    $message = \sprintf("Not able to handle type '%s'", $type);
    parent::__construct($message);
  }
}
