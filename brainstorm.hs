
-- Type Synonyms, type families, GADTs, Kind Sigs...
-- ... Can be a lot nicer.

-- Summary:
--    * synonyms are syntacticly like functions,
--      except upper case names
--    * type families are like functions, just as
--      synonyms but with cases.
--    * GADTs are block like.


-- synonym
Foo :: Type -> Type
Foo a = (a, a -> a, Int)

-- GADT
List :: Type -> Type
List = data
	Null :: List a
	Cons :: a -> List a -> List a

-- type family
Bar :: Type -> Type
Bar Int    = String
Bar String = Int

-- instead of this monstrosity:
type family Bar a :: *
type instance Bar Int = String
type instance Bar String = Int

-- constraints can be guards :)
-- They're *kind of* like Type -> Bool
Bar2 :: Type -> Type
Bar2 a | Show a = a
Bar2 _ = ()

-- With constraint kinds...
NumShow :: Type -> Constraint
NumShow a = (Show a, Num a)

-- Instead of the non-trivially unintuitive:
NumShow :: * -> Constraint
type NumShow a = (Show a, Num a)

-- Instance declarations
Num [a] | Num a = instance
	(+) = zipWith (+)
	...

-- You get the idea.

-- Scoped type variables by default.
-- I can't imagine why they aren't
-- It makes it much easier to catch bugs
-- inside complicated code.

foo :: Eq a => [a] -> a -> [a]
foo l e = 
	let
		l' :: [a]
		l' = filter (== e) l
	in
		l' ++ l' ++ l'

-- That summarizes the type level stuff.
-- I have less ideas about values, but...

-- Why do we only have _ in patterns?

curry = _ (_, _)

-- There are *lots* of silly re-organizational functions that are unneeded if you have this.

-- Also lots of code like this:

f x y z = g x y z 1

-- Can be replaced with:

f = g _ _ _ 1

-- This can also make type level things clearer....

Monad [_] = instance ...
Functor [_] = instance ...
Functor (a, _) = instance ...

-- Because what were people thinking with Monad [] ?!?!

-- One still has the strangeness of this not being valid:

Functor (_, a) = instance ...

-- But it's just like with not being able to declare certain synonym instances.

-- Serious consideration for synonym names for Monad and Functor (DoAble, MapAble?)

-- What do you think? What would you change?
