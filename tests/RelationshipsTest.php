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

use type Facebook\TypeAssert\TestFixtures\ChildClass;
use function Facebook\FBExpect\expect;
use type Facebook\TypeAssert\TestFixtures\ParentClass;

final class RelationshipsTest extends \Facebook\HackTest\HackTest {
  public function testObjectInstanceOfOwnClass(): void {
    $x = new ParentClass();
    expect(namespace\instance_of(ParentClass::class, $x))->toBeSame($x);
  }

  public function testObjectInstanceOfParentClass(): void {
    $x = new ChildClass();
    expect(namespace\instance_of(ParentClass::class, $x))->toBeSame($x);
  }

  public function testObjectInstanceOfChildClassThrows(): void {
    expect(() ==> {
      namespace\instance_of(ChildClass::class, new ParentClass());
    })->toThrow(IncorrectTypeException::class);
  }

  public function testObjectInstanceOfUnrelatedClassThrows(): void {
    expect(() ==> {
      namespace\instance_of(\stdClass::class, new ParentClass());
    })->toThrow(IncorrectTypeException::class);
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
    expect(      namespace\classname_of(ParentClass::class, ParentClass::class),
)->toBeSame(
      ParentClass::class    );
  }

  public function testClassnameIsClassnameOfParent(): void {
    expect(      namespace\classname_of(ParentClass::class, ChildClass::class),
)->toBeSame(
      ChildClass::class    );
  }

  public function testClassnameIsNotClassnameOfChild(): void {
    expect(() ==> {
      namespace\classname_of(ChildClass::class, ParentClass::class);
    })->toThrow(IncorrectTypeException::class);
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
