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
