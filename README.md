TypeAssert [![Build Status](https://travis-ci.org/hhvm/type-assert.svg?branch=master)](https://travis-ci.org/hhvm/type-assert)
==========

Hack library for converting untyped data to typed data.

Warning for `TypeAssert\matches_type_structure()`
--------------------------------------------------

`TypeStructure<T>`, `type_structure()`, and `ReflectionTypeAlias::getTypeStructures()`
are experimental features of HHVM, and not supported by Facebook or the HHVM team.
This means that `matches_type_structure()` may need to be removed in a future release
without warning.

We strongly recommend moving to `TypeAssert\matches<T>()` and
`TypeCoerce\match<T>()` instead.

Installation
------------

```
composer require hhvm/type-assert
```

Usage
-----

TypeAssert provides functions that take a mixed input, and will
either return it unmodified (but with type data) or throw an exception; for example:

```Hack
<?hh // strict
use namespace Facebook\TypeAssert;
function needs_string(string $bar): void {
}

function main(): void {
  needs_string(TypeAssert\string('foo')); // type-safe and works fine
  needs_string(TypeAssert\string(123)); // type-safe, but throws
}
```

These include:
 - `string(mixed): string`
 - `int(mixed): int`
 - `float(mixed): float`
 - `bool(mixed): bool`
 - `resource(mixed): resource`
 - `num(mixed): num`
 - `arraykey(mixed): arraykey`
 - `not_null<T>(?T): T`
 - `instance_of<T>(classname<T>, mixed): T`
 - `classname_of<T>(classname<T>, mixed): classname<T>`
 - `matches<T>(mixed): T`
 - `matches_type_structure<T>(TypeStructure<T>, mixed): T`

Coercion
--------

TypeAssert also contains the `Facebook\TypeCoerce` namespace, which includes a
similar set of functions:

 - `string(mixed): string`
 - `int(mixed): int`
 - `float(mixed): float`
 - `bool(mixed): bool`
 - `resource(mixed): resource`
 - `num(mixed): num`
 - `arraykey(mixed): arraykey`
 - `match<T>(mixed): T`
 - `match_type_structure<T>(TypeStructure<T>, mixed): T`

These will do 'safe' transformations, such as int-ish strings to int, ints to
strings, arrays to vecs, arrays to dicts, and so on.

TypeSpec
--------

You can also assert/coerce complex types (except for shapes and tuples) without
a type_structure:

```Hack
<?hh

use namespace Facebook\TypeSpec;

$spec = TypeSpec\dict(
  TypeSpec\string(),
  TypeSpec\int(),
);
$x = $spec->assertType(dict['foo' => 123]); // passes: $x is a dict<string, int>
$x = $spec->assertType(dict['foo' => '123']); // fails
$x = $spec->assertType(dict[123 => 456]); // fails
$x = $spec->assertType(dict[123 => 456]); // fails

$x = $spec->coerceType(dict[123 => '456']); // passes: $x is dict['123' => 456];
```

Shapes and tuples are not supported, as they can not be expressed generically.

`matches_type_structure<T>(TypeStructure<T>, mixed): T`
-----------------------------------------------------

Asserts that a variable matches the given type structure; these can be arbitrary
nested shapes. This is particular useful for dealing with JSON responses.

```Hack
<?hh // strict

use namespace Facebook\TypeAssert;

class Foo {
  const type TAPIResponse = shape(
    'id' => int,
    'user' => string,
    'data' => shape(
      /* ... */
    ),
  );

  public static function getAPIResponse(): self::TAPIResponse {
    $json_string = file_get_contents('https://api.example.com');
    $array = json_decode($json_string, /* associative = */ true);
    return TypeAssert\matches_type_structure(
      type_structure(self::class, 'TAPIResponse'),
      $array,
    );
  }
}
```

You can use `type_structure()` to get a `TypeStructure<T>` for a type constant,
or `ReflectionTypeAlias::getTypeStructure()` for top-level type aliases.

`not_null<T>(?T): T`
---------------------

Throws if it's null, and refines the type otherwise - for example:

```Hack
<?hh // strict
use namespace \Facebook\TypeAssert;

function needs_string(string $foo): void {}
function needs_int(int $bar): void {}

function main(?string $foo, ?int bar): void {
  needs_string(TypeAssert\not_null($foo)); // ?string => string
  needs_int(TypeAssert\not_null($bar)); // ?int => int
}
```

`is_instance_of<T>(classname<T>, mixed): T`
-----------------------------------------

Asserts that the input is an object of the given type; for example:

```Hack
<?hh
use namespace Facebook\TypeAssert;

class Foo {}

function needs_foo(Foo $foo): void {}

function main(mixed $foo): void {
  needs_foo(TypeAssert::is_instance_of(Foo::class, $foo));
}

main(new Foo());
```

`is_classname_of<T>(classname<T>, mixed): classname<T>`
------------------------------------------------------------

Asserts that the input is the name of a child of the specified class, or
implements the specified interface.

```Hack
<?hh // strict
use namespace Facebook\TypeAssert;

class Foo {
  public static function doStuff(): void {}
}
class Bar extends Foo {
  <<__Override>>
  public static function doStuff(): void {
    // specialize here
  }
}

function needs_foo_class(classname<Foo> $foo): void {
  $foo::doStuff();
}

function main(mixed $class): void {
  needs_foo_class(TypeAssert::is_classname_of(Foo::class, $class));
}

main(Bar::class);
```


Credit
------

This library is a reimplementation of ideas from:

 - @admdikramr
 - @ahupp
 - @dlreeves
 - @periodic1236
 - @schrockn

Security Issues
---------------

We use GitHub issues to track public bugs. Please ensure your description is
clear and has sufficient instructions to be able to reproduce the issue.

Facebook has a [bounty program](https://www.facebook.com/whitehat/) for the safe
disclosure of security bugs. In those cases, please go through the process
outlined on that page and do not file a public issue.

License
-------

Type-Assert is MIT-licensed.
