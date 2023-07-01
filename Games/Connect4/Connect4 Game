-- Haskell
main :: IO()
main = do
  let board = make_board 8 6
  event_loop board 1

event_loop :: Board -> Int -> IO()
event_loop board player = do
  putStrLn $ draw_board board

  if is_won board then do
    win_message board player
    return ()
  else do
    col <- get_move player
    handle_move board player col

make_board :: Int -> Int -> Board
make_board cols rows = []
--    [ [0 | _ <- [1..cols] ] | _ <- [1..rows] ]

next_ player = 3 - player

get_move player = do
  putStrLn $ "(Enter -99 to quit.)"
  putStrLn $ "Player " ++(show player)++" moves."
  putStr $ "Column [0-6]? "
  x <- getLine
  return (get_number x)

-- get_number returns -1 for any invalid input
get_number :: String -> Int
get_number colIn
    = case (reads colIn)::[(Int,String)] of
        [(colnum, "")] -> colnum
        _              -> -1
                       
handle_move board player col
    | col == -99              = goodbye
    | is_legal_move board col = event_loop new_board (next_ player)
    | otherwise = complain_and_restart
    where complain_and_restart = do
              putStrLn "ERROR: That is not a legal move."
              event_loop board player
          new_board = make_move board col player
          goodbye = do putStrLn "You quit"

win_message board player = do
    putStrLn $ "The game is over"
    putStrLn $ "Player "++(show $ next_ player)++" won!"
    -- note: win computed at the start of the next turn
    -- so current player is the loser       

type Player = Int -- really only two choices
type Posn = (Int, Int) -- coordinates
type Piece = (Player, Posn)
type Board = [Piece]

stuffer:: String -> [String] -> String
stuffer a [] = ""
stuffer a (x:xs) = x ++ a ++ (stuffer a xs)
score1:: Player -> [Player] -> Int
score1h a [] = 1
score1h a (x:xs)
  | x == 0 = (score1h a xs)
  | x == a = 10 * (score1h a xs)
  | otherwise = 0
score1 a b = (score1h a b)`quot` 10

in_box:: (Int, Int) -> (Int, Int) -> [Posn] -> [Posn]
in_box (x,x1) (y,y1) a = [(b,c) | (b,c) <- a, b >= x && b <= x1 && c >= y && c <= y1]
keep_all_in_box:: (Int, Int) -> (Int, Int) -> [[Posn]] -> [(Posn)]
keep_all_in_box _ _ [] = []
keep_all_in_box (x,x1) (y,y1) (a:as) = [(b,c)| (b,c) <- a, in_box (x,x1) (y,y1) a == a] ++ keep_all_in_box (x,x1) (y,y1) as

ex_board_1 = [(1,(1,0)), (1,(2,0)), (1,(3,0)), (1,(4,0))]
ex_board_2 = [(1,(1,0)), (1,(2,0)), (2,(2,1)), (2,(3,0)), (2,(5,0))]
ex_board_3 = [(1,(1,0)), (2,(1,1)), (1,(1,2)), (2,(1,3)), (1,(1,4)), (2,(1,5))]
draw n 
  | n == 1 = "X"
  | n == 2 = "O"
drawrow:: [(Int, (Int, Int))] -> String -> String
drawrow [] a = a
drawrow ((a,(x,y)):xs) b = take 7 (drawrow xs ((take x b) ++ draw a ++ (drop (x + 1) b)))
draw_board :: Board -> String
draw_board b = (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y == 5] "       ") ++ "\n" ++ (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y == 4] "       ") ++ "\n" ++ (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y == 3] "       ") ++ "\n" ++ (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y == 2] "       ")++ "\n"++ (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y ==1] "       ") ++ "\n" ++ (drawrow [((a,(x,y))) | (a,(x,y)) <- b, y == 0] "       ")

make_move :: Board -> Int -> Player -> Board
make_move a n n1 = [(n1, (n, (sfy a n)))] ++ a

sfy:: Board -> Int -> Int
sfy n b = length (filter (==b) [x | (a,(x,y)) <- n])

is_legal_move :: Board -> Int -> Bool
is_legal_move a n =  (sfy a n) <= 6 && n `elem` [0..6]

addPosn :: (Num a) => (a,a) -> (a,a) -> (a,a)
addPosn (a,b) (x,y) = (a+x, b+y)
ck1b = addPosn (3,4) (8,15) == (11,19) 

goForever :: (Int,Int) -> (Int,Int) -> [(Int,Int)]
goForever (a,b) (x,y) = [(a,b)] ++ goForever (addPosn (a,b) (x,y)) (x,y)

goFour (a,b) (x,y) = take 4 (goForever (a,b) (x,y)) 
ck3 = goFour (1,4) (2,-1) == [(1,4),(3,3),(5,2),(7,1)]

allFours:: (Int, Int) -> [[(Int, Int)]]
allFours (a,b) = [goFour (a,b) (x,y) | (x,y) <- [(1,0), (1,1), (0,1), (-1,1), (-1,0), (-1,-1), (0,-1), (1,-1)]]

is_wonx :: Board -> [[(Int, Int)]]
is_wonx [] = [[]]
is_wonx n@((a,(x,y)):as) = [b | b <- allFours (x,y), 4 == is_wonh n b] ++ is_wonx as
is_wonh:: Board -> [(Int, Int)] -> Int
is_wonh _ [] = 0
is_wonh n@((a,(x,y)):as) b = sum [1 | (q,r) <- b, (q,r) `elem` [(x,y) | (a,(x,y)) <- n]]
is_won b = not (null [n | n <- [is_wonx [(a,(x,y)) | (a,(x,y)) <- b, a == 1]], not (n == [[]])])
