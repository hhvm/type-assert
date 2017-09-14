<?hh // strict
/*
 * Copyright (c) 2017, Facebook Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeSpec\__Private;

final class Trace {
  const type TFrame = string;
  private vec<self::TFrame> $frames = vec[];

  public function withFrame(self::TFrame $frame): this {
    $new = clone $this;
    $new->frames[] = $frame;
    return $new;
  }

  public function getFrames(): vec<self::TFrame> {
    return $this->frames;
  }
}
