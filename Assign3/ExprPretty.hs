{-|
Module : ExprPretty
Description : Contains a type class and instances for
differentiable expressions
Copyright : (c) Kexin Liu @2018
License : WTFPL
Maintainer : liuk44@mcmaster.ca
Stability : experimental
Portability : POSIX
-}

module ExprPretty where

import ExprType

{- Instance Show Expr
 -     Privides a pretty representation of our datatype
 -     Matching the DSL provided in DiffExpr
 -}


parens :: String -> String 
parens ss = "(" ++ ss ++ ")"

instance Show a => Show (Expr a) where
    show (Add e1 e2) = parens (show e1) ++ " !+ " ++ parens (show e2)
    show (Mult e1 e2) = parens (show e1) ++ " !* " ++ parens (show e2)
    show (Var ss) = parens $ "var \"" ++ ss ++ "\""
    show (Const x) = parens $ "val " ++ show x  
    show (Cos e) = parens $ "cos " ++ show e
    show (Sin e) = parens $ "sin " ++ show e
    show (Ln e) = parens $ "log " ++ show e
    show (Expt b e) = parens (show b) ++ " !^ " ++ parens(show e)
    show (Exp e) = parens $ "e " ++ show e