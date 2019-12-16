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

use namespace HH\Lib\Vec;
use namespace Facebook\TypeSpec;
use type Facebook\TypeSpec\TypeSpec;

final class ShapeSpecTest extends TypeSpecTest<shape(...)> {
  const type TShapeA = shape(
    'string_field' => string,
    ?'optional_string_field' => string,
    'nullable_string_field' => ?string,
    ?'optional_nullable_string_field' => ?string,
  );

  const type TShapeWithExtraFields = shape(
    'int_field' => int,
    ...
  );

  <<__Override>>
  public function getInvalidValues(): vec<(mixed)> {
    return Vec\filter(
      parent::getInvalidValues(),
      $it ==> !$it[0] is dict<_, _>,
    );
  }

  <<__Override>>
  public function getTypeSpec(): TypeSpec<shape(...)> {
    return TypeSpec\__Private\from_type_structure(
      type_structure(self::class, 'TShapeA'),
    );
  }

  <<__Override>>
  public function getValidCoercions(): vec<(mixed, shape(...))> {
    return vec[
      tuple(
        darray['string_field' => 'foo', 'nullable_string_field' => null],
        shape('string_field' => 'foo', 'nullable_string_field' => null),
      ),
      tuple(
        dict['string_field' => 'foo', 'nullable_string_field' => null],
        shape('string_field' => 'foo', 'nullable_string_field' => null),
      ),
      tuple(
        darray['string_field' => 123, 'nullable_string_field' => 'bar'],
        shape('string_field' => '123', 'nullable_string_field' => 'bar'),
      ),
      tuple(
        darray[
          'string_field' => 123,
          'nullable_string_field' => 'bar',
          'optional_string_field' => 123,
        ],
        shape(
          'string_field' => '123',
          'optional_string_field' => '123',
          'nullable_string_field' => 'bar',
        ),
      ),
      tuple(
        darray[
          'string_field' => 123,
          'nullable_string_field' => 'bar',
          'optional_nullable_string_field' => 123,
        ],
        shape(
          'string_field' => '123',
          'nullable_string_field' => 'bar',
          'optional_nullable_string_field' => '123',
        ),
      ),
      tuple(
        darray[
          'string_field' => 123,
          'nullable_string_field' => 'bar',
          'optional_nullable_string_field' => null,
        ],
        shape(
          'string_field' => '123',
          'nullable_string_field' => 'bar',
          'optional_nullable_string_field' => null,
        ),
      ),

    ];
  }

  <<__Override>>
  public function getInvalidCoercions(): vec<(mixed)> {
    return vec[
      tuple(false),
      tuple(123),
      tuple('foobar'),
    ];
  }

  <<__Override>>
  public function getToStringExamples(): vec<(TypeSpec<shape(...)>, string)> {
    return vec[tuple(
      $this->getTypeSpec(), <<<EOF
shape(
  'string_field' => string,
  ?'optional_string_field' => string,
  'nullable_string_field' => ?string,
  ?'optional_nullable_string_field' => ?string,
)
EOF
    )];
  }
}
