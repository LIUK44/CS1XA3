{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FlexibleInstances #-}

{-|
Module : ExprDiff
Description : Contains a type class and instances for
differentiable expressions
Copyright : (c) Kexin Liu @2018
License : WTFPL
Maintainer : liuk44@mcmaster.ca
Stability : experimental
Portability : POSIX
TODO write a longer description of the module,
containing some commentary with @some markup@.
-}

module ExprDiff where

import           ExprType
import ExprPretty

import qualified Data.Map as Map

{- Class DiffExpr:
 -     Differentiable Expressions
 - ----------------------------------------------
 - This class has methods over the Expr datatype
 - that assists with construction and evaluation
 - of differentiable expressions
 - --------------------------------------------------------
 - Methods:
 -        eval - takes a dictionary of variable identifiers
 -               and values, and uses it to compute the
 -               Expr fully
 -        simplify - takes a possibly incomplete dictionary 
 -                   and uses it to reduce Expr as much as 
 -                   possible 
 -                   Add (Add (Var "x") (Const 1)) (Add (Const 2) (Var "y"))
 -                   => Add (Const 3) (Add (Var "x") (Add (Var "y"))
 -               eg. e1 = x + y
 -                   e2 = y + x
 -                   simplify e1 == simplify e2 


 -        partDiff - given an var identifier, differentiate
 -                   IN TERMS of that identifier
 -        Default Methods - !+, !*, !^, var, val : are functions
 -                          wrappers for Expr constructors that
 -                          perform additional simplification
 -}

class DiffExpr a where  
    eval :: Map.Map String a -> Expr a -> a

    simplify :: Map.Map String a -> Expr a -> Expr a

    partDiff :: String -> Expr a -> Expr a

    {- Default Methods -}
    (!+) :: Expr a -> Expr a -> Expr a
    e1 !+ e2 = simplify (Map.fromList []) $ Add e1 e2

    (!*) :: Expr a -> Expr a -> Expr a
    e1 !* e2 = simplify (Map.fromList []) $ Mult e1 e2

    (!^) :: Expr a -> Expr a -> Expr a
    e1 !^ e2 = simplify (Map.fromList []) $ Expt e1 e2

    val :: a -> Expr a
    val e = Const e

    var :: String -> Expr a
    var x = Var x

    -- | Checks if the expression is already in simplified form 
    simplified :: Map.Map String a -> Expr a -> Bool



{- Most intuative instance of DiffExpr
 - Num instannces only relies on +,-
 - Float instances relies on the rest operations 
 - Methods:
 -        eval : Takes a list of tuples of the type [(String, Num)] and an expression, plug in the value of variable if possible and evaluate it
 -        simplify : Takes a list of tuples of the type [(String, Num)] and an expression, plug in the value of variable if possible and simplify it
 -        partDiff : This function performs partial defferentiation with respect to its parameter.
 -}

instance (Num a, Floating a, Eq a) => DiffExpr a where  

    -- * Evaluation Part

    eval vrs (Add e1 e2) = eval vrs e1 + eval vrs e2
    eval vrs (Mult e1 e2) = eval vrs e1 * eval vrs e2
    eval vrs (Const e) = e
    eval vrs (Var x) = case Map.lookup x vrs of
                         Just v -> v
                         Nothing -> error "Failed lookup in eval."
    eval vrs (Cos e) = cos (eval vrs e)
    eval vrs (Sin e) = sin (eval vrs e)
    eval vrs (Ln e) = log (eval vrs e)
    eval vrs (Expt b e) = (eval vrs b) ** (eval vrs e)
    eval vrs (Exp e) = exp (eval vrs e)
    
    -- * Simplification Part

    simplified vrs e = (simplify vrs e) == e

    -- ** Simplifying basic Add operations
    
    {- | Addition Associative Law
         Always write constants to the left-most
    -}
    simplify vrs (Add e1 (Add e2 e3)) = simplify vrs (Add (simplify vrs (Add e1 e2)) (simplify vrs e3)) 

    simplify vrs (Add e1 e2) = case e2 of                                                
                                 Var x   -> case Map.lookup x vrs of                                     -- ^ If e2 is a variable, then looks up if variable is assigned to a value
                                            Just v -> Const (eval vrs (Add e1 e2))                       -- ^ Yes, then plug in the value and gives a constant
                                            Nothing -> Add (Const (eval vrs e1)) (Var x)                 -- ^ No, then leaves the variable there 
                                 Add a b -> Add (simplify vrs e1) (simplify vrs (Add a b))               -- ^ If e2 is a long expression, sets it apart and puts it back to simplify function 
                                 _       -> case e1 of                                                   -- ^ e2 is of other circumstances, thus check e1
                                              Var x -> simplify vrs (Add e2 e1)                          -- ^ e1 is a variable, then reverses the order of e1 and e2, puts them back to simplify function
                                              Add a b -> Add (simplify vrs e2) (simplify vrs (Add a b))  -- ^ a long expression, simplify it
                                              _     -> Const $ eval vrs $ Add e1 e2                      -- ^ Both e1 and e2 are not variables, thus we can add them together
    

    
    simplify vrs (Add (Const 0) (Var x)) = Var x -- ^ Example : x + 0 = x
    simplify vrs (Add (Var x) (Const 0)) = Var x

    
    -- | Addition Communicative Law
    simplify vrs (Add (Var x) (Var y)) 
        | x == y = Mult (Const 2) (Var x) -- ^ x + x = 2x 
        | otherwise = Add (Var y) (Var x) -- ^ x + y = y + x

    

    -- ** Simplifying basic Mult operations

    {- | Multiplication Associative Law
         Always write constants to the left-most
    -}
    simplify vrs (Mult e1 (Mult e2 e3)) = simplify vrs (Mult (simplify vrs (Mult e1 e2)) (simplify vrs e3)) 

    simplify vrs (Mult e1 e2) = case e2 of 
                                 Var x   -> case Map.lookup x vrs of                       -- ^ Basically do the same things as add simplification
                                            Just v -> Const (eval vrs (Mult e1 e2))        -- ^ plug in the given value for the variable then multiply them together
                                            Nothing -> Mult (Const (eval vrs e1)) (Var x)  -- ^ lookup failed, then leave the variable there
                                 Mult a b -> Mult (simplify vrs e1) (simplify vrs (Mult a b))
                                 _       -> case e1 of
                                              Var x -> simplify vrs (Mult e2 e1)
                                              Mult a b -> Mult (simplify vrs e2) (simplify vrs (Mult a b))
                                              _     -> Const $ eval vrs $ Mult e1 e2      

    simplify vrs (Mult (Const 0) (Var x)) = Const 0 -- ^ x * 0 = 0
    simplify vrs (Mult (Var x) (Const 0)) = Const 0

    simplify vrs (Mult (Const 1) e2) = e2 -- ^ 1 * x = x
    simplify vrs (Mult e1 (Const 1)) = e1

    -- | Multiplication Communicative Law
    simplify vrs (Mult (Var x) (Var y)) 
        | x == y = Expt (Var x) (Const 2)  -- ^ x * x = x^2
        | otherwise = Mult (Var y) (Var x) -- ^ x * y = y * x

    -- | Distribution Law
    simplify vrs (Mult e1 (Add e2 e3)) = simplify vrs (Add (Mult e1 e2) (Mult e1 e3)) 


    -- ** Simplifying Const, Var, Cos, Sin, Ln, and Expt functions
    
    simplify vrs (Const e) = Const e
    simplify vrs (Var x) = case Map.lookup x vrs of
                             Just num -> Const (eval vrs (Var x))
                             Nothing  -> Var x

    -- *** Simplifying cosine function
    simplify vrs (Cos (Const e)) = Const (eval vrs (Cos (Const e)))
    simplify vrs (Cos e) = case (simplified vrs e) of
                              True -> (Cos (simplify vrs e))
                              False -> simplify vrs (Cos (simplify vrs e)) 
    
    -- *** Simplifying sine function
    simplify vrs (Sin (Const e)) = Const (eval vrs (Sin (Const e)))
    simplify vrs (Sin e) = case (simplified vrs e) of
                              True -> (Sin (simplify vrs e))
                              False -> simplify vrs (Sin (simplify vrs e)) 

    -- *** Simplifying natural log function
    simplify vrs (Ln (Const 1)) = Const 0
    simplify vrs (Ln (Exp (Const 1))) = Const 1
    simplify vrs (Ln (Const e)) = Const (eval vrs (Ln (Const e)))
    simplify vrs (Ln e) = case (simplified vrs e) of
                            True -> (Ln (simplify vrs e))
                            False -> simplify vrs (Ln (simplify vrs e))

    -- *** Simplifying power function
    simplify vrs (Expt (Const 1) e) = e
    simplify vrs (Expt _ (Const 0)) = Const 1
    simplify vrs (Expt (Const e1) (Const e2)) = Const (eval vrs (Expt (Const e1) (Const e2)))
    simplify vrs (Expt (Var x) (Var y)) = case (Map.lookup x vrs) of
                                            Just v -> case (Map.lookup y vrs) of
                                                        Just t -> Const (eval vrs (Expt (Var x) (Var y)))
                                                        Nothing -> Expt (simplify vrs (Var x)) (simplify vrs (Var y))
                                            Nothing -> Expt (simplify vrs (Var x)) (simplify vrs (Var y)) 
    simplify vrs (Expt (Var x) (Const e2)) = case Map.lookup x vrs of
                                               Just v -> Const (eval vrs (Expt (Var x) (Const e2)))
                                               Nothing -> Expt (Var x) (Const e2)
    simplify vrs (Expt (Const e1) (Var x)) = case Map.lookup x vrs of
                                                Just v -> Const (eval vrs (Expt (Const e1) (Var x)))
                                                Nothing -> Expt (Const e1) (Var x) 
    simplify vrs (Expt e1 e2) = case  ((simplified vrs e1) || (simplified vrs e2)) of
                                         True -> (Expt (simplify vrs e1) (simplify vrs e2))
                                         False -> simplify vrs (Expt (simplify vrs e1) (simplify vrs e2))
    
    -- *** Simplifying exponential function
    simplify vrs (Exp (Const 0)) = Const 1
    simplify vrs (Exp e) = case (simplified vrs e) of
                             True -> (Exp (simplify vrs e))
                             False -> simplify vrs (Exp (simplify vrs e)) 

    -- * Partial Differentiation Part
 
    partDiff v (Add e1 e2) = Add (partDiff v e1) (partDiff v e2) 
    partDiff v (Mult e1 e2) = Add (Mult (partDiff v e1) e2) (Mult e1 (partDiff v e2)) 
    partDiff _ (Const _) = Const 0 

    partDiff v (Var x) 
        | v == x = (Const 1)  
        | otherwise = (Const 0)

    partDiff v (Cos e) = Mult (Mult (Const (-1)) (Sin e)) (partDiff v e)
    partDiff v (Sin e) = Mult (Cos e) (partDiff v e)
    partDiff v (Ln e) = Mult (Expt e (Const (-1))) (partDiff v e)
    partDiff v (Expt (Const b) (Var e)) = Mult ((Expt (Const b) (Var e))) (Ln (Const b))
    partDiff v (Expt (Var x) e) = Mult (Mult e (Expt (Var x) (Add e (Const (-1))))) (partDiff v (Var x))   
    partDiff v (Exp e) = Mult (Exp e) (partDiff v e)
                                                                                                
  
  

  



























