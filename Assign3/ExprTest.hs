{-|
Module : ExprTest
Description : Contains a type class and instances for
differentiable expressions
Copyright : (c) Kexin Liu @2018
License : WTFPL
Maintainer : liuk44@mcmaster.ca
Stability : experimental
Portability : POSIX
-}

module ExprTest where

import ExprType
import ExprDiff
import ExprParser
import ExprPretty

import qualified Data.Map as Map
--import Test.QuickCheck


{- | Test cases for my assignment. -}

-- * Tests eval in ExprDiff
evalProp1 :: Double -> Double -> Bool
evalProp1 a b = eval (Map.fromList [("x",a),("y",b)]) (Add (Var "x") (Var "y")) == a + b
testeval1 = quickCheck evalProp1

evalProp2 :: Double -> Double -> Bool
evalProp2 a b = eval (Map.fromList [("x",a), ("y",b)]) (Mult (Var "x") (Var "y")) == a * b
testeval2 = quickCheck evalProp2

evalProp3 :: Double -> Bool
evalProp3 a = eval (Map.fromList [("x",a)]) (Cos (Var "x")) == cos(a)
testeval3 = quickCheck evalProp3

evalProp4 :: Double -> Bool
evalProp4 a = eval (Map.fromList [("x",a)]) (Sin (Var "x")) == sin(a)
testeval4 = quickCheck evalProp4

evalProp5 :: Double -> Bool
evalProp5 a = eval (Map.fromList [("x",a)]) (Ln (Var "x")) == log(a)
testeval5 = quickCheck evalProp5

evalProp6 :: Double -> Double -> Bool
evalProp6 a b = eval (Map.fromList [("x",a),("y",b)]) (Expt (Var "x") (Var "y")) == a ** b
testeval6 = quickCheck evalProp6

evalProp7 :: Double -> Bool
evalProp7 a = eval (Map.fromList [("x",a)]) (Exp (Var "x")) == exp(a)
testeval7 = quickCheck evalProp7



-- * Tests simplify in ExprDiff

simProp1 :: Double -> Bool
simProp1 a = simplify (Map.fromList [("x",a)]) (Add (Const 0) (Var "x")) == Const a
testsim1 = quickCheck testsim1

simProp2 :: Double -> Bool
simProp2 a = simplify (Map.fromList [("x",a)]) (Mult (Const 0) (Var "x")) == Const 0
testsim2 = quickCheck testsim2

simProp3 :: Double -> Bool
simProp3 a = simplify (Map.fromList [("x",a)]) (Mult (Const 1) (Var "x")) == Const a
testsim3 = quickCheck testsim3

simProp4 :: Double -> Double -> Bool
simProp4 a b = simplify (Map.fromList []) (Add (Const a) (Add (Const b) (Var "x"))) == Add (Const (a+b)) (Var "x")
testsim4 = quickCheck testsim4

simProp5 :: Double -> Double -> Bool
simProp5 a b = simplify (Map.fromList []) (Mult (Const a) (Mult (Const b) (Var "x"))) == Mult (Const (a*b)) (Var "x")
testsim5 = quickCheck testsim5

simProp6 :: Double -> Double -> Bool
simProp6 a b = simplify (Map.fromList [("x",a),("y",b)]) (Add (Var "x") (Var "y")) == simplify (Map.fromList [("x",a),("y",b)]) (Add (Var "y") (Var "x"))
testsim6 = quickCheck testsim6

simProp7 :: Double -> Double -> Bool
simProp7 a b = simplify (Map.fromList [("x",a),("y",b)]) (Mult (Var "x") (Var "y")) == simplify (Map.fromList [("x",a),("y",b)]) (Mult (Var "y") (Var "x"))
testsim7 = quickCheck testsim7 

simProp8 :: Double -> Bool
simProp8 a = simplify (Map.fromList [("x",a)]) (Cos (Var "x")) == Const (cos a)
testsim8 = quickCheck testsim8

simProp9 :: Double -> Bool
simProp9 a = simplify (Map.fromList [("x",a)]) (Sin (Var "x")) == Const (sin a)
testsim9 = quickCheck testsim9

simProp10 :: Double -> Bool
simProp10 a = simplify (Map.fromList [("x",a)]) (Ln (Var "x")) == Const (log a)
testsim10 = quickCheck testsim10

simProp11 :: Double -> Bool
simProp11 a = simplify (Map.fromList [("x",a)]) (Expt (Const 1) (Var "x")) == Const 1
testsim11 = quickCheck testsim11

simProp12 :: Double -> Bool
simProp12 a = simplify (Map.fromList [("x",a)]) (Expt (Var "x") (Const 0)) == Const 1
testsim12 = quickCheck testsim12

simProp13 :: Double -> Bool
simProp13 a = simplify (Map.fromList [("x",a)]) (Expt (Var "x") (Const 1)) == Var "x"
testsim13 = quickCheck testsim13



-- * Tests partDiff in ExprDiff


diffProp1 :: String -> Double -> Bool
diffProp1 s a = partDiff s (Const a) == Const 0
testdiffProp1 = quickCheck diffProp1 


diffProp2 :: String -> Bool
diffProp2 s = partDiff s (Var s) == Const 1
testdiff2 = quickCheck diffProp2


-- | If diff c*x gives c
diffProp3 :: String -> Double -> Bool
diffProp3 s a = partDiff s (Mult (Const a) (Var s)) == Add (Mult (Const 0) (Var s)) (Mult (Const a) (Const 1))
testdiff3 = quickCheck diffProp3

-- | If diff cos(x) gives -sin(x)
diffProp4 :: String -> Double -> Bool
diffProp4 s a = partDiff s (Cos (Var s)) == Mult (Mult (Const (-1)) (Sin (Var s))) (Const 1)
testdiff4 = quickCheck diffProp4


-- | If diff sin(x) gives cos(x)
diffProp5 :: String -> Double -> Bool
diffProp5 s a = partDiff s (Sin (Var s)) == Mult (Cos (Var s)) (Const 1)
testdiff5 = quickCheck diffProp5


-- | If diff ln(x) gives 1/x
diffProp6 :: String -> Double -> Bool
diffProp6 s a = partDiff s (Ln (Var s)) == Mult (Expt (Var s) (Const (-1))) (Const 1)
testdiff6 = quickCheck diffProp6


-- | If diff e^c gives 0
diffProp8 :: String -> Double -> Bool
diffProp8 s a = partDiff s (Exp (Const a)) == Mult (Exp (Const a)) (Const 0)
testdiff8 = quickCheck diffProp8

-- | If diff e^x gives e^x
diffProp9 :: String -> Double -> Bool
diffProp9 s a = partDiff s (Exp (Var s)) == Mult (Exp (Var s)) (Const 1)
testdiff9 = quickCheck diffProp9



-- * Tests parse for variables in ExprParser
-- | This has to be tested manually since quickCheck cannot randomly plug in string variable


parseProp1 :: String -> String -> Bool
parseProp1 x y = parseExprI (x ++ "+" ++ y) == Add (Var x) (Var y) 

parseProp2 :: String -> String -> Bool
parseProp2 x y = parseExprI (x ++ "*" ++ y) == Mult (Var x) (Var y) 

parseProp3 :: String -> String -> Bool
parseProp3 x y = parseExprI (x ++ "^" ++ y) == Expt (Var x) (Var y) 

parseProp4 ::  String -> Bool
parseProp4 x = parseExprI2 ("cos" ++ x) == Cos (Var x)

parseProp5 ::  String -> Bool
parseProp5 x = parseExprI2 ("sin" ++ x) == Sin (Var x)

parseProp6 ::  String -> Bool
parseProp6 x = parseExprI2 ("e" ++ x) == Exp (Var x)



-- * Tests parse for numbers in ExprParser
parseProp7 :: Double -> Double -> Bool
parseProp7 a b = parseExprD (show a ++ "+" ++ show b) == Add (Const a) (Const b)
testparse7 = quickCheck parseProp7

parseProp8 :: Double -> Double -> Bool
parseProp8 a b = parseExprD (show a ++ "*" ++ show b) == Mult (Const a) (Const b)
testparse8 = quickCheck parseProp8

parseProp9 :: Double -> Double -> Bool
parseProp9 a b = parseExprD (show a ++ "^" ++ show b) == Expt (Const a) (Const b)
testparse9 = quickCheck parseProp9

parseProp10 ::  Double -> Bool
parseProp10 a = parseExprD2 ("cos" ++ show a) == Cos (Const a)
testparse10 = quickCheck parseProp10

parseProp11 ::  Double -> Bool
parseProp11 a = parseExprD2 ("sin" ++ show a) == Sin (Const a)
testparse11 = quickCheck parseProp11

parseProp12 ::  Double -> Bool
parseProp12 a = parseExprD2 ("e" ++ show a) == Exp (Const a)
testparse12 = quickCheck parseProp12



