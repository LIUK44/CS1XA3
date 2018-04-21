# Assignment3 Documentation
## Requirement
Build a math library in haskell for helping you with your Calculus homework. It should provide at least the following functionality:
- An expression datatype that can encode
   - Addition, Multiplication
   - Cos, Sin, Log, Exp (natural)
   - Variables
   - Constants
   - Can partially evaluate an expression (or fully)
   - Can perform partial differentiation (symbolic)
   - Can parse certain strings into an expression datatype (specify required format in documentation)
   
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
ExprDiff module contains a DiffExpr type class and instances for eval, simplify, and partDiff equations.
-  `eval` --  Evaluation
- `partDiff` -- Perform partial differention
  ```sh
  diff a = 0 
  ```
  ```sh
  diff c*x = c
  ```
  ```sh
  diff cos(x) = -sin(x) 
  ```
   ```sh
  diff sin(x) = cos(x) 
  ```
   ```sh
  diff ln(x) = 1/x
  ```
   ```sh
  diff a^x = ln(a)*a^x 
  ```
   ```sh
  diff x^n = n * x^(n-1) 
  ```
   ```sh
  diff e^x = e^x
  ```
- `simplify` -- Perform partial or full simplification
   - Addition 
   ```sh
   a + (b + c) = (a + b) + c   -- Associative Law 
   ```
     ```sh
   x + x = 2x
   x + y = y + x   -- Communicative Law
   ```
   ```sh
   0 + a = a 
   ```
   - Multiplication
   ```sh
   0 + a = a   -- Associative Law
   ```
   ```sh
   x * x = x^2
   x * y = y * x   -- Communicative Law
   ```
   ```sh
   0 * x = 0
   1 * x = x
   ```
   - Distribution Law
   ```sh
   a * (b + c) = a * b + a * c 
   ```
   - Cos and Sin
   - Ln
   ```sh
   ln(1) = 0
   ln(e) = 1
   ```
   - Expt
   ```sh
   1^b = 1
   a^0 = 1
   a^1 = a
   ```
   - Exp
   ```sh
   e^0 = 1
   e^1 = 1 
   ```


Note: The simplification cannot perform perfectly, thus one way to fix this is to keep the constants to the left-most. 


## ExprParser
ExprParser module contains Parsers to parse a string to an expression of Expr a.

| Type Encoding  | String Representation |
| ------ | ------ |
| val 1.0 | 1 |
| var "x" | x |
| (val -1) !*  var "x" | - x | 
| val 1 !+ (var "x")) | 1 + x|
| val 2 !* var "x" | 2 * x |
| cos (var "x") | cosx |
| sin (var "x") | sin x |
| expt (var "x") (val 2) | x ^ 2 |
| expt (val 2) (var "x") | 2 ^ x |
| ln (var "x") | ln x |

**Reference:** Since some of the constructors in (Expr a) only have one parameter, `chainl` does not work in this case, so we need to define another parseExpr for each type again. Get the idea from @barskyn on gitHub. Source code: [Here](https://github.com/barskyn/CS1XA3/blob/master/Assign3/assign3/ExprParser.hs)

## ExprPretty
ExprPretty module privides a pretty representation of our datatype matching the DSL provided in DiffExpr.
1. Add a b = a "!+" b
2. Mult a b = a !* " b
3. Var x = var "x"
4. Const a = val a  
5. Cos a = cos a
6. Sin a = sin a
7. Ln a = log a
8. Expt a b = a "!^" b
9. Exp a = e a


## ExprTest
ExprTest module contains test cases and quickCheck to test over eval, simplify, partDiff functions in ExprDiff module and parseExpr* in ExprParser module

Note:
Test cases for partDiff functions have to be done mannually, since quickCheck method cannot randomly plug in variable of string type




##### Copyright Kexin Liu @ 2018