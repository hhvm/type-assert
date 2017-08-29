<?hh // strict
/*
 * Copyright (c) 2016, Fred Emmott
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

final class UnsupportedTypeException extends \Exception {
  public function __construct(
    string $type,
  ) {
    $message = sprintf("Not able to handle type '%s'", $type);
    parent::__construct($message);
  }
}
