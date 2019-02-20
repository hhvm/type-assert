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

use type Facebook\TypeSpec\Trace;
use namespace HH\Lib\{C, Vec};

trait ExceptionWithSpecTraceTrait {
  require extends \Exception;

  abstract public function getSpecTrace(): Trace;

  final public function getMessage(): string {
    $message = parent::getMessage();
    $frames = $this->getSpecTrace()->getFrames();
    if (C\is_empty($frames)) {
      return $message;
    }
    return \sprintf(
      "%s\nType trace:\n%s\n",
      $message,
      $frames
      |> Vec\reverse($$)
      |> Vec\map_with_key($$, ($depth, $frame) ==> '#'.$depth.' '.$frame)
      |> \implode("\n", $$),
    );
  }
}
