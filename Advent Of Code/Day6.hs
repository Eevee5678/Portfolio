import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = (lines x1)!!0
  let x3 = solve x2
  print x3

different a b c d 
  | a /= b && b /= c && c /= d && a/= d && b /= d && a/= c = True
  | otherwise = False

unique:: [Char] -> [Char] -> [Bool]
unique "" _ = []
unique (a:as) b = [a `elem` b] ++ unique as b 

solve1:: String -> String -> String
solve1 [a] x = x
solve1 [a,b] x = x
solve1 [a,b,c] x = x
solve1 y@(a:b:c:d:as) x 
  | null y = x
  | different a b c d = [a,b,c,d] ++ x
  | otherwise = solve1 (b:c:d:as) (x ++ [a])

help [] = []
help y = [a | a <- take 14 y, b <- take 14 y, a == b]

solve:: String -> Int
solve [] = 0
solve c@(y:ys) 
  | sum [1 | a <- take 14 c, b <- take 14 c, a == b] == 14 = 14
  | otherwise = 1 + solve ys
