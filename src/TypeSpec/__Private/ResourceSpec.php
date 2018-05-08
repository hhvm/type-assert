<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec\__Private;

use type Facebook\TypeAssert\{IncorrectTypeException, TypeCoercionException};
use type Facebook\TypeSpec\TypeSpec;

final class ResourceSpec extends TypeSpec<resource> {
  public function __construct(private ?string $kind = null) {
  }
  use NoCoercionSpecTrait<resource>;

  public function assertType(mixed $value): resource {
    if (!is_resource($value)) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->getPrettyType(),
        $value,
      );
    }

    $kind = $this->kind;
    if ($kind !== null && \get_resource_type($value) !== $kind) {
      throw IncorrectTypeException::withValue(
        $this->getTrace(),
        $this->getPrettyType(),
        $value,
      );
    }

    return $value;
  }

  private function getPrettyType(): string {
    $kind = $this->kind;
    if ($kind === null) {
      return 'resource';
    }
    return 'resource<'.$kind.'>';
  }
}
