{-|
Module : ExprType
Description : Contains a type class and instances for
differentiable expressions
Copyright : (c) Kexin Liu @2018
License : WTFPL
Maintainer : liuk44@mcmaster.ca
Stability : experimental
Portability : POSIX
-}

module ExprType where

import Data.List

{- Expression Datatype
 -	----------------------------------------
 - Wraps different operations in a
 - Expression Tree
 - Ops:
 -     Add - standard binary addition
 -     Mult - standard binary multiplication
 -     Const - wrapper for simple values
 -     Var - string identifier for variables
 -     Cos - unary cosine function
 -     Sin - unary sine function
 -     Ln - unary natural log function
 -     Expt - binary power function
 -     Exp - unary exponential function
 -}

-- | DataType Decleration
data Expr a = Add (Expr a) (Expr a) 
            | Mult (Expr a) (Expr a)
            | Const a
            | Var String
            | Cos (Expr a)
            | Sin (Expr a)
            | Ln (Expr a)
            | Expt (Expr a) (Expr a)
            | Exp (Expr a) 
   deriving Eq

{- getVars: 
 -         retrieves variable identifiers from
 -         an Expr type
 -}
 
-- | Miscellaneous Functions
getVars :: Expr a -> [String] 
getVars (Add e1 e2) = getVars e1 `union` getVars e2  
-- ^ get variables from expression e1 and e2, then concatetates to a list of variables
getVars (Mult e1 e2) = getVars e1 `union` getVars e2 
getVars (Const _) = []                               
-- ^ Since there are no variables in constants, we will get an empty list
getVars (Var ident) = [ident] 
getVars (Cos e) = getVars e
getVars (Sin e) = getVars e
getVars (Ln e) = getVars e
getVars (Expt e1 e2) = getVars e1 `union` getVars e2


