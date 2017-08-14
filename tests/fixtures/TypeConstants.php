<?hh // strict
/*
 *  Copyright (c) 2016, Fred Emmott
 *  All rights reserved.
 *
 *  This source code is licensed under the ISC license found in the LICENSE
 * file in the root directory of this source tree.
 */

namespace FredEmmott\TypeAssert\TestFixtures;

class TypeConstants {
  const type TInt = int;
  const type TBool = bool;
  const type TFloat = float;
  const type TString = string;
  const type TNum = num;
  const type TArrayKey = arraykey;
  const type TTuple = (string, int);
  const type TStringArray = array<string>;
  const type TStringStringArray = array<string, string>;

  const type TNullableString = ?string;

  const type TStdClass = \stdClass;
  const type TStringVector = Vector<string>;
  const type TStringStringMap = Map<string, string>;
  const type TStringVectorVector = Vector<Vector<string>>;

  const type TFlatShape = shape(
    'someString' => string,
    'someNullable' => ?string,
  );

  const type TNestedShape = shape(
    'someString' => string,
    'someOtherShape' => self::TFlatShape,
  );

  const type TShapeWithContainer = shape(
    'container' => Vector<string>,
  );

  const type TEnum = ExampleEnum;
}
