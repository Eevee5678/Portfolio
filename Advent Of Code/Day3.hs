import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = lines x1
  let x3 = breaker2 x2
  print $ sum x3
  
key = zip (['a'..'z'] ++ ['A'..'Z']) [1..52]
partof a b = take 1 [y | (x,y) <- key, n <- [x | x <- a, x `elem` b], n == x]
breaker [] = []
breaker (a:as) = (partof(take ((length a)`div` 2) a) (drop ((length a) `div` 2)a)) ++ breaker as

partof2 a b c = take 1 [y | (x,y) <- key, n <- [x | x <- a, x `elem` b && x `elem` c], n == x]
breaker2 [] = []
breaker2 (a:b:c:as) = (partof2 a b c) ++ breaker2 as
