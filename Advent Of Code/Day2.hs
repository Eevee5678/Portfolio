import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = lines x1
  let x3 = part2 (breaker x2)
  print $ sum x3

breaker [] = []
breaker a = [(x!!0, x!!2) | x <- a]

legend (x,y)
  | y == 'Y' = ([1,2,3]!!((keyhh x)-1)) + 3
  | y == 'X' = ([3,1,2]!!((keyhh x)-1)) 
  | y == 'Z' = ([2,3,1]!!((keyhh x)-1)) + 6

keyhh a
  | a == 'Y' || a == 'B'= 2
  | a == 'X' || a == 'A' = 1
  | a == 'Z' || a == 'C' = 3
  
keyh (x,y)
  | x == 'A'&& y == 'Y' = 6 + (keyhh y)
  | x == 'B' && y == 'Z' = 6 + (keyhh y)
  | x == 'C' && y == 'X' = 6 + (keyhh y)
  | (x == 'A' && y == 'X') = 3 + (keyhh y)
  | (x == 'B' && y == 'Y') = 3 + (keyhh y)
  | (x == 'C' && y == 'Z') = 3 + (keyhh y)
  | otherwise = 0 + (keyhh y)

key a = [keyh (x,y) | (x,y) <- a]
part2 a = [legend (x,y) | (x,y) <- a]
