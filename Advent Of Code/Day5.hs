import System.IO
help1 :: [String] -> [Int]
help1 xs = map read xs
main = do
  x1 <- readFile "demo.txt"
  let x2 = lines x1
  let x3 = breaker x2
  let x4 = column x3
  let moves = movesBreak (drop ((length x3)+2) x2)
  print [head a| a <- movef2 x4 moves]

breakLine :: String -> [String]
breakLine "" = []
breakLine x = [x!!1] : (breakLine (drop 4 x))

breaker [] = []
breaker (x:xs)
  | null xs = []
  | (x!!1) == '1' = []
  | otherwise = (breakLine (x ++ " ")) : (breaker xs)

movesBreak :: [String] -> [[Int]]
movesBreak x = [map read ((words y !! 1) : (words y !! 3) : [words y !! 5]) | y <- x]

letter x = [y | y <- x, not (y == " ")]
column :: [[String]] -> [[String]]
column [[]] = [[]]
column x = letter [head y | y <- x] : column [tail y | y <- x]

move1 :: [[String]] -> Int -> Int -> [[String]]
move1 a x y = map move (zip a [0..2]) 
  where 
    store = head (a !! (x-1))
    move:: ([String], Int) -> [String]
    move (b, n) 
      | n == x - 1 = tail b
      | n == y - 1 = store: b
      | otherwise = b

movefinal:: [[String]] -> [[Int]] -> [[String]]
movefinal x ([a,b,c]:as)
  | a > 1 = movefinal (move1 x b c) ([(a-1),b,c]:as)
  | null as = move1 x b c
  | otherwise = movefinal (move1 x b c) as

move2 a x y n = map move (zip a [0..8])
  where 
    store = (a !! (x-1))
    move (b,z)
      | z == x - 1 = drop n b
      | z == y - 1 = take n store ++ b
      | otherwise = b

movef2:: [[String]] -> [[Int]] -> [[String]]
movef2 x [] = x
movef2 x ([a,b,c]:as) = movef2 (move2 x b c a) as
