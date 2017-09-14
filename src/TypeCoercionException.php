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

use type Facebook\TypeSpec\__Private\Trace as SpecTrace;
use type Facebook\TypeSpec\__Private\ExceptionWithSpecTraceTrait;

final class TypeCoercionException extends \Exception {
  use ExceptionWithSpecTraceTrait;

  public function __construct(
    private SpecTrace $specTrace,
    private string $target,
    private string $actual,
  ) {
    $message = sprintf('Could not coerce %s to type %s', $actual, $target);
    parent::__construct($message);
  }

  public function getSpecTrace(): SpecTrace {
    return $this->specTrace;
  }

  public function getTargetType(): string {
    return $this->target;
  }

  public function getActualType(): string {
    return $this->actual;
  }

  public static function withValue(
    SpecTrace $trace,
    string $expected,
    mixed $value,
  ): this {
    return new self(
      $trace,
      $expected,
      is_object($value) ? get_class($value) : gettype($value),
    );
  }
}
