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

use type Facebook\TypeSpec\Trace;
use type Facebook\TypeSpec\__Private\ExceptionWithSpecTraceTrait;

final class IncorrectTypeException extends \Exception {
  use ExceptionWithSpecTraceTrait;

  public function __construct(
    private Trace $specTrace,
    private string $expected,
    private string $actual,
  ) {
    $message = \sprintf('Expected %s, got %s', $expected, $actual);
    parent::__construct($message);
  }

  public function getSpecTrace(): Trace {
    return $this->specTrace;
  }

  public static function withType(
    Trace $trace,
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
    Trace $trace,
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
