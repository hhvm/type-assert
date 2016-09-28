TypeAssert [![Build Status](https://travis-ci.org/fredemmott/type-assert.svg?branch=master)](https://travis-ci.org/fredemmott/type-assert)
==========

Hack library for converting untyped data to typed data.

Usage
-----

```Hack
<?hh
function needs_string(string $foo): void {
}

function main(mixed $foo): void {
  needs_string(TypeAssert::isString($foo));
}
```

See [the TypeAssert class](https://github.com/fredemmott/type-assert/blob/master/src/TypeAssert.php) for full API.

```Hack
<?hh
class Foo {
  const TAPIResponse = shape(
    'id' => int,
    'user' => string,
    'data' => shape(
      /* ... */
    ),
  );

  public static function getAPIResponse(): self::TAPIResponse {
    $json_string = file_get_contents('https://api.example.com');
    $array = json_decode($json_string, /* associative = */ true);
    return TypeAssert::matchesTypeStructure(
      type_structure(self::class, 'TAPIResponse'),
      $array,
    );
  }
}
```

WARNING
-------

`TypeStructure<T>` and the `type_structure()` API are experimental
features of HHVM, and not supported. Expect them to break with some future
HHVM release.

This library uses them anyway as there is not currently an alternative
way to do this.

Credit
------

This library is a reimplementation of ideas from:

 - @admdikramr
 - @ahupp
 - @dlreeves
 - @periodic1236
 - @schrockn

The good ideas are theirs, any mistakes are mine :)

License
-------

This software is distributed under the ISC license - see LICENSE file
in this directory for details.
