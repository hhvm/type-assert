<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

final class TypeCoercionException extends \Exception {
  public function __construct(
    private string $target,
    private string $actual,
  ) {
    $message = sprintf('Could not coerce %s to type %s', $target, $actual);
    parent::__construct($message);
  }

  public function getTargetType(): string {
    return $this->target;
  }

  public function getActualType(): string {
    return $this->actual;
  }

  public static function fromValue(string $expected, mixed $value): this {
    return new self(
      $expected,
      is_object($value) ? get_class($value) : gettype($value),
    );
  }
}
