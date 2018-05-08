<?hh // strict
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

use Facebook\TypeAssert\TestFixtures\ChildClass;
use Facebook\TypeAssert\TestFixtures\ParentClass;

final class RelationshipsTest extends \PHPUnit\Framework\TestCase {
  public function testObjectInstanceOfOwnClass(): void {
    $x = new ParentClass();
    $this->assertSame($x, namespace\instance_of(ParentClass::class, $x));
  }

  public function testObjectInstanceOfParentClass(): void {
    $x = new ChildClass();
    $this->assertSame($x, namespace\instance_of(ParentClass::class, $x));
  }

  public function testObjectInstanceOfChildClassThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\instance_of(ChildClass::class, new ParentClass());
  }

  public function testObjectInstanceOfUnrelatedClassThrows(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\instance_of(\stdClass::class, new ParentClass());
  }

  public function testObjectInstanceOfTypechecks(): void {
    return; // this test is just here for hh_client

    $f = (ParentClass $x) ==> {
    };
    $f(namespace\instance_of(ParentClass::class, new ParentClass()));
    $f(namespace\instance_of(ParentClass::class, new ChildClass()));
    // Would actually throw
    $f(namespace\instance_of(ParentClass::class, new \stdClass()));
    // Would actually throw
    $f(namespace\instance_of(ParentClass::class, 'hello, world'));
  }

  public function testClassnameIsClassnameOfSelf(): void {
    $this->assertSame(
      ParentClass::class,
      namespace\classname_of(ParentClass::class, ParentClass::class),
    );
  }

  public function testClassnameIsClassnameOfParent(): void {
    $this->assertSame(
      ChildClass::class,
      namespace\classname_of(ParentClass::class, ChildClass::class),
    );
  }

  public function testClassnameIsNotClassnameOfChild(): void {
    $this->expectException(IncorrectTypeException::class);
    namespace\classname_of(ChildClass::class, ParentClass::class);
  }

  public function testClassnameOfTypechecks(): void {
    return; // this test is just here for hh_client

    $f = (classname<ParentClass> $x) ==> {
    };
    $f(namespace\classname_of(ParentClass::class, ParentClass::class));
    $f(namespace\classname_of(ParentClass::class, ChildClass::class));
    // Would actually throw
    $f(namespace\classname_of(ChildClass::class, ParentClass::class));
    // Would actually throw
    $f(namespace\classname_of(ParentClass::class, 'hello, world'));
  }
}
