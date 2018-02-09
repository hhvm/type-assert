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

use type Facebook\TypeSpec\Trace as SpecTrace;
use type Facebook\TypeSpec\__Private\ExceptionWithSpecTraceTrait;

final class IncorrectTypeException extends \Exception {
  use ExceptionWithSpecTraceTrait;

  public function __construct(
    private SpecTrace $specTrace,
    private string $expected,
    private string $actual,
  ) {
    $message = \sprintf('Expected %s, got %s', $expected, $actual);
    parent::__construct($message);
  }

  public function getSpecTrace(): SpecTrace {
    return $this->specTrace;
  }

  public static function withType(
    SpecTrace $trace,
    string $expected_type,
    string $actual_type,
  ): IncorrectTypeException {
    return new self(
      $trace,
      \sprintf("type '%s'", $expected_type),
      \sprintf("type '%s'", $actual_type),
    );
  }

  public static function withValue(
    SpecTrace $trace,
    string $expected_type,
    mixed $value,
  ): IncorrectTypeException {
    $actual_type = \gettype($value);
    if ($actual_type === 'object') {
      $actual_type = \get_class($value);
    }
    return self::withType($trace, $expected_type, $actual_type);
  }

  public function getExpectedType(): string {
    return $this->expected;
  }

  public function getActualType(): string {
    return $this->actual;
  }
}
