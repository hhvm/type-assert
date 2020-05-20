/*
 *  Copyright (c) 2016, Fred Emmott
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

// Imaginary application code
namespace {
  use type Facebook\TypeSpec\TypeSpec;
  newtype UserID = int;

  // Advice from: Hack and HHVM: Programming Productivity Without Breaking Things
  // I can recommend, it is a good read and a timemachine to the early days of Hack.
  function is_user_id(int $user_id): bool {
    return $user_id > (2 ** 48);
  }

  namespace MyTypeSpec {
    use type Facebook\TypeAssert\{
      IncorrectTypeException,
      TypeCoercionException,
    };

    /*HHAST_IGNORE_ERROR[CamelCasedMethodsUnderscoredFunctions] This is the name of the type*/
    function UserID(): TypeSpec<\UserID> {
      return new _Private\UserIDSpec();
    }

    namespace _Private {

      final class UserIDSpec extends TypeSpec<\UserID> {

        <<__Override>>
        public function assertType(mixed $value): \UserID {
          if (!$value is int || !\is_user_id($value)) {
            throw IncorrectTypeException::withValue(
              $this->getTrace(),
              $this->toString(),
              $value,
            );
          }
          return $value;
        }

        // This is NoCoercionSpecTrait, but that is in the _Private namespace.
        <<__Override>>
        public function coerceType(mixed $value): \UserID {
          try {
            return $this->assertType($value);
          } catch (IncorrectTypeException $e) {
            throw TypeCoercionException::withValue(
              $this->getTrace(),
              $e->getExpectedType(),
              $value,
            );
          }
        }

        <<__Override>>
        public function toString(): string {
          return 'UserID';
        }
      }
    }
  }
}
