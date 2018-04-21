# Assignment3 Documentation

## ExprType
ExprType module creates a data type `Expr a` which has the following constructors:
1. Add
```sh
(Add (Const 1) (Var "x")) represents 1 + x
```
2. Mult 
```sh
(Mult (Const 2) (Var "x")) represents 2x
```
3. Const
4. Var
5. Cos
6. Sin
7. Ln
8. Expt
```sh
(Expt (Var "x") (Var "")) represents x^y
```
9. Exp
```sh
(Exp (Var "x")) represents e^x
```

## ExprDiff

## ExprParser

## ExprPretty

## ExprTest



















##### Copyright Kexin Liu @ 2018