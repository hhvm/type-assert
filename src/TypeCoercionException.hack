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

final class TypeCoercionException extends \Exception {
  use ExceptionWithSpecTraceTrait;

  public function __construct(
    private Trace $specTrace,
    private string $target,
    private string $actual,
  ) {
    $message = \sprintf('Could not coerce %s to type %s', $actual, $target);
    parent::__construct($message);
  }

  public function getSpecTrace(): Trace {
    return $this->specTrace;
  }

  public function getTargetType(): string {
    return $this->target;
  }

  public function getActualType(): string {
    return $this->actual;
  }

  public static function withValue(
    Trace $trace,
    string $expected,
    mixed $value,
  ): this {
    return new self(
      $trace,
      $expected,
      \is_object($value) ? \get_class($value) : \gettype($value),
    );
  }
}
