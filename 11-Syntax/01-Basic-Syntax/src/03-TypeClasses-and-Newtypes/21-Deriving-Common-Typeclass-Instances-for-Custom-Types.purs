module Syntax.Deriving.Typeclass where

import Prelude


-- Given the following type classes, Eq and Ord

-- | Determines whether two instances of the same type are equal
class Eq_ a where
  eq_ :: a -> a -> Boolean


data Ordering_ = LT_ | GT_ | EQ_

-- | Determines whether left is less than, greater than, or equal to right
class Ord_ a where
  compare_ :: a -> a -> Ordering_

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/3.markdown
-- Changes made: use meta-language to explain type class derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
data Type
  = First Int
  | Second String

-- To create instances of `Eq` and `Ord` for `Type` we'd usually write it by hand:
instance eqType :: Eq Type where
  eq (First a) (First b) = a == b
  eq (Second a) (Second b) = a == b
  eq _ _ = false

instance ordType :: Ord Type where
  compare (First a) (First b) = compare a b
  compare (First _) _ = LT
  compare (Second a) (Second b) = compare a b
  compare (Second _) _ = GT

-- Imagine if we added a Third constructor to Type. We'd need to account for
--   that type as well now.
-- This gets tedious and, fortunately, the compiler can figure out what these
-- should be based on the 'shape' of the types. To reduce the boilerplate,
-- we can just add `derive` in front of the instance and not implement
-- the function:

data Type2
  = First2 Int
  | Second2 String

derive instance eqType2 :: Eq Type2
derive instance ordType2 :: Ord Type2

-- In other cases (like higher-kinded types),
-- we can use type class constraints to derive them:
data Box a = Box a
derive instance eqMaybe :: Eq a => Eq (Box a)
derive instance ordMaybe :: Ord a => Ord (Box a)

{-
Note: this works for only two reasons:

First, because Int and String
  both have an Eq and Ord instance. If one of these did not,
  then the compiler would not know how to create them.

Second, because we can only derive typeclasses from a few
  type classes:
  - Data.Eq (from `purescript-prelude`)
  - Data.Ord (from `purescript-prelude`)
  - Data.Functor (from `purescript-prelude`)
  - Data.Newtype (from `purescript-newtype`)
  - Data.Generic.Rep (from `purescript-generics-rep`)
-}
