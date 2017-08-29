<?hh // strict
/*
 * Copyright (c) 2016, Fred Emmott
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace FredEmmott\TypeAssert;

final class IncorrectTypeException extends \Exception {
  public function __construct(
    string $expected,
    string $actual,
  ) {
    $message = sprintf(
      'Expected %s, got %s',
      $expected,
      $actual,
    );
    parent::__construct($message);
  }

  public static function withType(
    string $expected_type,
    string $actual_type,
  ): IncorrectTypeException {
    return new self(
      sprintf("type '%s'", $expected_type),
      sprintf("type '%s'", $actual_type),
    );
  }

  public static function withValue(
    string $expected_type,
    mixed $value,
  ): IncorrectTypeException {
    $actual_type = gettype($value);
    if ($actual_type === 'object') {
      $actual_type = get_class($value);
    }
    return self::withType($expected_type, $actual_type);
  }
}
