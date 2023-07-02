import Data.List
import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = lines x1
  let x3 = breaker2 x2 []
  let x4 = map help1 x3
  print $ solve2 x4
  putStrLn "Happiness"
  
breaker1 :: [String] -> [String]
breaker1 [] = []
breaker1 ("":xs) = []
breaker1 (a:xs) = a: breaker1 xs

breaker2:: [String] -> [String] -> [[String]]
breaker2 [] b = [b]
breaker2 ("":xs) b = b: breaker2 xs []
breaker2 (a:xs) b = breaker2 xs (b ++ [a])

solve:: [[Int]] -> Int
solve a = maximum[sum x | x <- a]

solve2:: [[Int]] -> Int
solve2 a = sum (take 3 (reverse (sort [sum x | x <- a])))

