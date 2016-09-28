TypeAssert [![Build Status](https://travis-ci.org/fredemmott/type-assert.svg?branch=master)](https://travis-ci.org/fredemmott/type-assert)
==========

Hack library for converting untyped data to typed data.

Requires HHVM 3.12 or newer.

Usage
-----

TypeAssert provides several static methods that take a mixed input, and will
either return it unmodified (but with type data) or throw an exception; for example:

```Hack
<?hh // strict
use \FredEmmott\TypeAssert\TypeAssert;
function need_string(string $bar): void {
}

function main(): void {
  needs_string(TypeAssert::isString('foo')); // type-safe and works fine
  needs_string(TypeAssert::isString(123)); // type-safe, but throws
}
```

These include:
 - `isString(mixed): string`
 - `isInt(mixed): int`
 - `isFloat(mixed): float`
 - `isBool(mixed): bool`
 - `isResource(mixed): resource`
 - `isNum(mixed): num`
 - `isArrayKey(mixed): arraykey`
 - `isNotNull<T>(?T): T`
 - `isInstanceOf<T>(classname<T>, mixed): T`
 - `isClassnameOf<T>(classname<T>, mixed): classname<T>`
 - `matchesTypeStructure<T>(TypeStructure<T>, mixed): T`

`matchesTypeStructure<T>(TypeStructure<T>, mixed): T`
-----------------------------------------------------

Asserts that a variable matches the given type structure; these can be arbitrary
nested shapes. This is particular useful for dealing with JSON responses.

```Hack
<?hh // strict
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
    return TypeAssert::matchesTypeStructure(
      type_structure(self::class, 'TAPIResponse'),
      $array,
    );
  }
}
```

You can use `type_structure()` to get a `TypeStructure<T>` for a type constant,
or `ReflectionTypeAlias::getTypeStructure()` for top-level type aliases.

### WARNING

`TypeStructure<T>`, `type_structure()`, and `ReflectionTypeAlias::getTypeStructures()`
are experimental features of HHVM, and not supported by Facebook or the HHVM team.
Expect them to break with some future HHVM release.

This library is based on these APIs anyway as there is not currently a viable
alternative.

`isNotNull<T>(?T): T`
---------------------

Throws if it's null, and refines the type otherwise - for example:

```Hack
<?hh // strict
use \FredEmmott\TypeAssert\TypeAssert;

function needs_string(string $foo): void {}
function needs_int(int $bar): void {}

function main(?string $foo, ?int bar): void {
  needs_string(TypeAssert::isNotNull($foo)); // ?string => string
  needs_int(TypeAssert::isNotNull($bar)); // ?int => int
}
```

`isInstanceOf<T>(classname<T>, mixed): T`
-----------------------------------------

Asserts that the input is an object of the given type; for example:

```Hack
<?hh
use \FredEmmott\TypeAssert\TypeAssert;

class Foo {}

function needs_foo(Foo $foo): void {}

function main(mixed $foo): void {
  needs_foo(TypeAssert::isInstanceOf(Foo::class, $foo));
}

main(new Foo());
```

`isClassnameOf<T>(classname<T>, mixed): classname<T>`
------------------------------------------------------------

Asserts that the input is the name of a child of the specified class, or
implements the specified interface.

```Hack
<?hh // strict
use \FredEmmott\TypeAssert\TypeAssert;

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
  needs_foo_class(TypeAssert::isClassnameOf(Foo::class, $class));
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

The good ideas are theirs, any mistakes are mine :)

License
-------

This software is distributed under the ISC license - see LICENSE file
in this directory for details.

I am providing the code to you under an open source license. Because this is my personal
repository, the license you receive to my code is from me and not from my employer (Facebook).
