{-|
Module : ExpParse
Description : Contains a type class and instances for
differentiable expressions
Copyright : (c) Kexin Liu @2018
License : WTFPL
Maintainer : liuk44@mcmaster.ca
Stability : experimental
Portability : POSIX
-}

module ExprParser (parseExprI, parseExprI2, parseExprInt, parseExprInt2, parseExprD, parseExprD2, parseExprF, parseExprF2) where

import ExprType
import Text.Parsec
import Text.Parsec.String


{- | 
 - parseExpr*
 - ----------------------------------------
 - Takes a string of format:
 -       "+", "*", "^", "cos", "sin", "ln", "e"
 - and parses an expression of Expr *

 -}


-- ｜ Pasrses a String to an Expr Integer Type
parseExprI :: String -> Expr Integer

parseExprI ss = case parse exprI "" ss of
                  Left err -> error "Invalid input for parsing integer."
                  Right expr -> expr


exprI :: Parser (Expr Integer)
exprI = termI `chainl1` binOp

termI :: Parser (Expr Integer)
termI = try numParserI <|> varParse


numParserI :: Parser (Expr Integer)
numParserI = do { a <- integer;
                  return (Const a)} 

-------------------------------------------------------------------------

-- ｜ Pasrses a String to an Expr Int Type
parseExprInt :: String -> Expr Int
parseExprInt ss = case parse exprInt "" ss of
                  Left err -> error "Invalid input for parsing int."
                  Right expr -> expr


exprInt :: Parser (Expr Int)
exprInt = termInt `chainl1` binOp

termInt :: Parser (Expr Int)
termInt = try numParserInt <|> varParse


numParserInt :: Parser (Expr Int)
numParserInt = do { a <- int;
                    return (Const a)} 


-------------------------------------------------------------------------
-- ｜ Pasrses a String to an Expr Double Type
parseExprD :: String -> Expr Double
parseExprD ss = case parse exprD "" ss of
                  Left err -> error "Invalid input for parsing double."
                  Right expr -> expr

exprD :: Parser (Expr Double)
exprD =  termD `chainl1` binOp


termD :: Parser (Expr Double)
termD = try numParserD <|> varParse


numParserD :: Parser (Expr Double)
numParserD = do { a <- double;
                  return (Const a)} 


-------------------------------------------------------------------------
-- ｜ Pasrses a String to an Expr Float Type
parseExprF :: String -> Expr Float
parseExprF ss = case parse exprF "" ss of
                  Left err -> error "Invalid input for parsing float."
                  Right expr -> expr


exprF :: Parser (Expr Float)
exprF = termF `chainl1` binOp

termF :: Parser (Expr Float)
termF = try numParserF <|> varParse


numParserF :: Parser (Expr Float)
numParserF = do { a <- float;
                  return (Const a)} 


---------------------------------------------------------------------------------------------------------------------
{- |
 - Unary operators have only one parameter in the constructors
 - Thus I defined some other parseExpr*2 functions to try to fix this problem
 - refrerence from @barskyn on gitHub
-}

parseExprI2 :: String -> Expr Integer
parseExprI2 ss = case parse exprI2 "" ss of
                Left err  -> error "Invalid input for parsing variable strings."
                Right expr -> expr 

exprI2 :: Parser (Expr Integer)
exprI2 = try (factor termI) <|> termI

----------------------------------------------------
parseExprInt2 :: String -> Expr Int
parseExprInt2 ss = case parse exprInt2 "" ss of
                Left err  -> error "Invalid input for parsing variable strings."
                Right expr -> expr 

exprInt2 :: Parser (Expr Int)
exprInt2 = try (factor termInt) <|> termInt              
----------------------------------------------------
parseExprD2 :: String -> Expr Double
parseExprD2 ss = case parse exprD2 "" ss of
                Left err  -> error "Invalid input for parsing variable strings."
                Right expr -> expr 

exprD2 :: Parser (Expr Double)
exprD2 = try (factor termD) <|> termD   
----------------------------------------------------
parseExprF2 :: String -> Expr Float
parseExprF2 ss = case parse exprF2 "" ss of
                Left err  -> error "Invalid input for parsing variable strings."
                Right expr -> expr 

exprF2 :: Parser (Expr Float)
exprF2 = try (factor termF) <|> termF 
----------------------------------------------------

factor :: Parser (Expr a) -> Parser (Expr a)
factor parseType = do {op <- unOp;
                       spaces;
                       newTerm <- parseType;
                       spaces;
                       return (op newTerm)}  
-----------------------------------------------------

-- | Binary operators
binOp :: Parser (Expr a -> Expr a -> Expr a) 
binOp = (do { symbol "+"; return Add })
     <|> do { symbol "*"; return Mult } 
     <|> do { symbol "^"; return Expt}

-- | Unary operators
unOp :: Parser (Expr a -> Expr a)   
unOp = (do { string "cos"; return Cos })
    <|> do { string "sin"; return Sin } 
    <|> do { string "ln"; return Ln}
    <|> do { string "e"; return Exp}

{- | 
 - Some other useful combinators that parses letter, digit, decimal, negative number, and checks space 
-}

varParse :: Parser (Expr a)
varParse = do { x <- many1 letter;
                return (Var x)} 

symbol :: String -> Parser String
symbol ss = let
  symbol' :: Parser String
  symbol' = do { spaces;
                 ss' <- string ss;
                 spaces;
                 return ss' }
  in try symbol'

digits :: Parser String
digits = many1 digit


negDigits :: Parser String
negDigits = do { symbol "-";
                 ds <- digits;
                 return ('-':ds) }



decimal :: Parser String
decimal = do { char '.';
               rest <- digits;
               return ('.':rest) }

doubleDigits :: Parser String
doubleDigits = do { ds <- try negDigits <|> digits ;
                    rs <- try decimal <|> return "" ;
                    return $ ds ++ rs }


{- Parses instance of integers -}
integer :: Parser Integer
integer = fmap read $ try negDigits <|> digits

{- Parses instance of ints -}
int :: Parser Int
int = fmap read $ try negDigits <|> digits

{- Parses instance of doubles -}
double :: Parser Double
double = fmap read $ doubleDigits

{- Parses instance of floats -}
float:: Parser Float
float = fmap read $ doubleDigits
