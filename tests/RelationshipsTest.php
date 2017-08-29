<?hh // strict
/*
 * Copyright (c) 2016, Fred Emmott
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\TypeAssert;

use Facebook\TypeAssert\TestFixtures\ChildClass;
use Facebook\TypeAssert\TestFixtures\ParentClass;

final class RelationshipsTest extends \PHPUnit\Framework\TestCase {
  public function testObjectInstanceOfOwnClass(): void {
    $x = new ParentClass();
    $this->assertSame($x, TypeAssert::isInstanceOf(ParentClass::class, $x));
  }

  public function testObjectInstanceOfParentClass(): void {
    $x = new ChildClass();
    $this->assertSame($x, TypeAssert::isInstanceOf(ParentClass::class, $x));
  }

  public function testObjectInstanceOfChildClassThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert::isInstanceOf(ChildClass::class, new ParentClass());
  }

  public function testObjectInstanceOfUnrelatedClassThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert::isInstanceOf(\stdClass::class, new ParentClass());
  }

  public function testObjectInstanceOfTypechecks(): void {
    return; // this test is just here for hh_client

    $f = (ParentClass $x) ==> {
    };
    $f(TypeAssert::isInstanceOf(ParentClass::class, new ParentClass()));
    $f(TypeAssert::isInstanceOf(ParentClass::class, new ChildClass()));
    // Would actually throw
    $f(TypeAssert::isInstanceOf(ParentClass::class, new \stdClass()));
    // Would actually throw
    $f(TypeAssert::isInstanceOf(ParentClass::class, 'hello, world'));
  }

  public function testClassnameIsClassnameOfSelf(): void {
    $this->assertSame(
      ParentClass::class,
      TypeAssert::isClassnameOf(ParentClass::class, ParentClass::class),
    );
  }

  public function testClassnameIsClassnameOfParent(): void {
    $this->assertSame(
      ChildClass::class,
      TypeAssert::isClassnameOf(ParentClass::class, ChildClass::class),
    );
  }

  public function testClassnameIsNotClassnameOfChild(): void {
    $this->expectException(IncorrectTypeException::class);
    TypeAssert::isClassnameOf(ChildClass::class, ParentClass::class);
  }

  public function testClassnameOfTypechecks(): void {
    return; // this test is just here for hh_client

    $f = (classname<ParentClass> $x) ==> {
    };
    $f(TypeAssert::isClassnameOf(ParentClass::class, ParentClass::class));
    $f(TypeAssert::isClassnameOf(ParentClass::class, ChildClass::class));
    // Would actually throw
    $f(TypeAssert::isClassnameOf(ChildClass::class, ParentClass::class));
    // Would actually throw
    $f(TypeAssert::isClassnameOf(ParentClass::class, 'hello, world'));
  }
}
