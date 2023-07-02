import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = lines x1
  let x3 = solver (breaker x2)
  let x4 = sol2 x3
  print $ length [x | x <- x4, x == True]

breaker1:: String -> [Char] -> String
breaker1 [] a = a
breaker1 (a:as) b 
  | a == '-' || a == ',' = breaker1 as (b ++ [' '])
  | otherwise = breaker1 as (b++ [a])

breaker [] = []
breaker (a:as) = words (breaker1 a []) ++ breaker as

solver:: [String] -> [Int]
solver a = [read x | x <- a]

sol2 [] = []
sol2 a = h3 (help [(a!!0)..(a!!1)] [(a!!2)..(a!!3)] (longer [(a!!0)..(a!!1)] [(a!!2)..(a!!3)])):sol2 (drop 4 a)

longer a b 
  | length a > length b = 2 
  | length a == length b = (if (head a >= head b) then 2 else  1)
  | otherwise = 1
  
h2 a = not ( False `elem` a)
h3 a = True `elem` a

help [] _ _ = []
help _ [] _ = []
help aa@(a:as) bb@(b:bs) x
  | x == 1 = [a `elem` bb ] ++ help as bb x 
  | x == 2 =  [b `elem` aa ] ++ help aa bs x
