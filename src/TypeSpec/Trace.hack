/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\TypeSpec;

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
