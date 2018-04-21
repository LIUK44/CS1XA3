# Assignment3 Documentation



## ExprType

The module contains a data type `Expe a` for Numerical expression and a function `getVars` to retrive variable identifiers from an expression.

The data type `Exp a` has constructors to encode:

1. binary addition and multiplication 
2. exponentation, with expression as base and number as exponent, e.g. (x+1)^2 could be expressed as:
```sh
Exp (Add (Var "x") (Const 1)) 2 
```
3. logarithm, to some numerical base of an expression, e.g. log2 (x+1) could be expresses as:
```sh
Log  2 (Add (Var "x") (Const 1))
```
4. unary trigonometry: sin, cos
5. unary natural logarithm: ln
6. wrappers for simple constants
7. string identifier for variables


The `getVars` finction could retrive variable identifiers from an expession and put these variable into a list without duplication.
```sh
>>> getVars (var "x" !+ var "y" !+ val 10)
["x","y"]
```



## ExprDiff

The module contains a type class `DiffExpr` and instances for differentiable expressions. 

The type class `DiffExpr` has :
- methods which need to be defined in instances:
   -  `eval`--  do evaluation
   - `simp` -- do some basic, first step simplification
   - `partDiff` -- do partial differention
   

- methods coming along with the class type, which are given by default:

   - `simplify` -- simplify the expression recursively based on the given `simp` rules untill it can't be reduced anymore
   - `!+` -- binary addition, takes 2 expressions, encodes addtion and simplification together,  and returns the resulting expr.
   - `!*` -- binary multiplaction, takes 2 expressions, encodes multiplation and simplification together, and returns the resulting expr.
   - `!^` -- exponentiation: takes an expr and a number, encodes exponentation and simplification together,  and returns the resulting expr.
   - `loga` -- logarithm of arbitory numerical base: takes a number as base and an expr, encodes logarithm and simplification together,  and returns the resulting expr.
   - `sine` -- unary sin op & simplification
   - `cosi` -- unary cos op & simplification
   - `ln` -- unary ln & simplification
   - `val` -- wrapper for simple values
   - `var` -- string identifier for variables


The instances are defined over 4 intuative Num type: Double, Float, Int, Integer.

As for `simplify` method, what you could expect it to do:
- substitute the variable identifier in the expr with the corresponding values given in the dictionary
- remove 0 item
- always make the constant item to the left-most
- add up all constants together in the expression no matter the order, and move the addition to the left-most.
- identify constants multiplied, and return the multiplication.
- do distribution law, commutative law 
 
For specific rules of simplification, check the file `SimpRules.log`



## ExprParser
The module contains parsers to parse a formatted string into the corresponding expression datatype.

Language specification for Expr over Number:

| Type Encoding  | String Representation |
| ------ | ------ |
| val   1  | 1  |
| val 1.0 | 1.0 |
|var "x" |     x  |
|(val -1) !*  var "x" |     - x | 
|val 1.0 !+ val 2.0 |     1.0 + 2.0  |
|val 1 !+ ((val -1) * (var "x")) | 1 - x|
| val 3 !* var "x" |     3 * x |
| exp (var "x") 2  |     x ^ 2 |
| loga 10 (var "x") |     log 10 x |
| sine (val 1) | sin 1 |
| cosi (var "x")   |cos x|
| ln (var "x")  |   ln x |
| val 3 !* ((var "x") ^ -1.0) |     3/x   | 


Note: 
1. parse the minus as (-1) * expr; 
2. parse the division as expr ^ (-1)



Language specification for Expr over Vector:

| Type Encoding  | String Representation |
| ------ | ------ |
|valV   [1,2,3,4] |     [1,2,3,4] |
|valV   [-1,-2,-3,-4]|  - [1,2,3,4]|
|varV "x" |     x  |
|valV [1,2,3] ?+ valV [4,5,6] | [1,2,3] + [4,5,6] |
|varV "x" ?+ valV [-1,-2,-3,-4]| x - [1,2,3,4]|
|valV [1,2,3] ?* varV [4,5,6]| [1,2,3] * [4,5,6]|
| valV [1,2,3] ?* varV "x" | [1,2,3] * x |
|sineV (valV [1,2,3]) | sin [1,2,3]|
|cosiV (varV "x") |  cos x |
|lnV (varV "x") | ln x|
|error  |     ... ^ ... |
|error  |     log ...| 
| error |     ... / ... |

Note:
1. parse negative vector "- [v1, v2,...] " as "[-v1, -v2, ...]"
2. parse minus operation "expr - [v1, v2,...]" as "expr + [-v1,-v2,...]"
2. try parsing "/" will return an error, cuz division is not available in Vector 


In this module, there's a helping class `ParserValue` to make parsers identify values of floating type and integral type, and to parse it correctly. This class also generalizes the steps of parsing differentiable expressions insteading of differing them into Double, Float, Int, Integer 4 basic types.


## ExprPretty

The module contains the customer Show instance of expression data type and provides a nicely printing-out form to expressions:

- bracket the items of each step of operations
- make constructor `Add` printing-out form as `+`
- make constructor `Mult` printing-out form as `*`
- make constructor `Exp` printing-out form as `^`
- make constructor `Log` printing-out form as `log`
- make constructor `Sin` printing-out dorm as `sin`
- make constructor `Cos` printing-out form as `cos`
- make constructor `Ln` printing-out form as `ln`
- make constructor `Val` printing-out form as `val`
- make constructor `Var` printing-out form as `var`

e.g.
```sh
>>> (var "x" !^ 2) !+ (val 3 !* var "y")
((var "x") ^ 2) + ((val 3) * (var "y"))
```
```sh
>>> varV "x" ?* sineV (valV [1,2,3] :: Expr [Float])
(val [0.84147096,0.9092974,0.14112]) * (var "x")
```

Note:

When try to parse some expressions, the body part of the advanced functions (exp, log, ln, sin, cos) has to be the simple expressions (expressions only composed of +, *, value, variable), or it could get into an infinite recursive parsing state.




## ExprTest

The module contains test cases and quickCheck methods over the functions defined in `ExprDiff` and `ExprVector` modules.

To see the specific properties of quickCheck, check the file `QuickCheckProp.log`.






##### Copyright Kexin Liu @ 2018
