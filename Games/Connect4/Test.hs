module TestConnectFour where

-- import ConnectFourSolution
import ConnectFour

-- signatures used:
{--
type BoardOld = [[Int]]

type Piece = (Player, Posn)
type Posn = (Int,Int)
type Player = Int
type Board = [Piece]
--}

-- The retrofit from BoardOld is a little weird.
-- you should include your own functions here:
-- draw_board
-- is_won
-- is_move_legal
-- make_move
-- boardConvertToMatrix
-- boardConvertToPieces

-- add in your own functions

draw_board' :: BoardOld -> String
-- draw_board' board = undefined 
draw_board' = drawBoard . bcp
              
is_won' :: BoardOld -> Bool
-- is_won' board = undefined
is_won' = is_won . bcp
          
is_move_legal' :: BoardOld -> Int -> Bool
-- is_move_legal' board col = undefined
is_move_legal' = is_move_legal . bcp

make_move' :: BoardOld -> Int -> Player -> BoardOld
-- make_move' board col player = undefined
make_move' b col player = bcm $ make_move (bcp b) col player

-- boardConvertToMatrix :: Int -> Int -> Board -> BoardOld
-- boardConvertToMatrix width height b = undefined

boardConvertToMatrix' :: Board -> BoardOld
boardConvertToMatrix' b = boardConvertToMatrix 7 6 b
-- abbreviation
bcm = boardConvertToMatrix'

boardConvertToPieces' :: BoardOld -> Board
boardConvertToPieces' = boardConvertToPieces
bcp = boardConvertToPieces'

board1 = [[0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0],
          [1,2,2,2,0,0,0],
          [1,1,1,2,0,0,0],
          [1,2,1,1,0,2,0]]

test1 = do
  putStrLn "\n\nTest 1\n"
  putStrLn $ draw_board' board1
  putStrLn $ "Is won? "++(show $ is_won' board1)
  return ()

board2 = make_move' board1 4 1

board2Correct = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [1,2,2,2,0,0,0],
                 [1,1,1,2,0,0,0],
                 [1,2,1,1,1,2,0]]

board3 = make_move' board2 4 2

board3Correct = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [1,2,2,2,0,0,0],
                 [1,1,1,2,2,0,0],
                 [1,2,1,1,1,2,0]]

test2 = do
  putStrLn "\n\nTest 2\n"
  putStrLn "move in column 4 for player 1"
  putStrLn $ draw_board' board2
  putStrLn $ "Board 2 ok? "++(show $ board2 == board2Correct)
  putStrLn "move in column 4 for player 2"
  putStrLn $ draw_board' board3
  putStrLn $ "Board 3 ok? "++(show $ board3 == board3Correct)
  putStrLn "move in column 4 for player 2"
  putStrLn $ draw_board' board4
  putStrLn $ "Board 4 ok? "++(show $ board4 == board4Correct)
           
board4 = make_move' board3 4 2

board4Correct = [[0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0],
                 [1,2,2,2,2,0,0],
                 [1,1,1,2,2,0,0],
                 [1,2,1,1,1,2,0]]


board5 = [[0,0,1,0,0,0,0],
          [0,0,2,0,0,0,0],
          [0,0,1,0,0,0,0],
          [1,2,2,2,2,0,0],
          [1,1,1,2,2,0,0],
          [1,2,1,1,1,2,0]]


test3 = do
  putStrLn "\n\nTest 3\n"
  putStrLn $ "Left bounds of move ok? " ++ (show $ not $ is_move_legal' board5 (-1))
  putStrLn $ "Right bounds of move ok? " ++ (show $ not $ is_move_legal' board5 100)
  putStrLn $ "Full column ok? " ++ (show $ not $ is_move_legal' board5 2 )
  putStrLn $ "Non-full column ok? " ++ (show $ is_move_legal' board5 4 )

board6 = [[0,0,0,0,0,0],
          [0,1,0,2,0,0],
          [0,0,1,0,0,0],
          [0,0,0,1,0,0],
          [0,0,0,0,1,0],
          [0,0,0,0,0,0]]


board7 = [[2,0,0,0,0,2],
          [0,0,0,2,1,0],
          [0,0,0,1,0,0],
          [0,0,1,1,0,0],
          [0,1,0,0,1,0],
          [2,0,0,0,0,0]]

board8 = [[2,0,0,0,0,0],
          [0,2,0,2,0,0],
          [0,2,1,0,0,0],
          [0,2,0,1,0,0],
          [0,2,0,0,1,0],
          [0,0,0,0,0,0]]


board9 = [[2,0,0,0,0,0],
          [0,1,0,2,0,0],
          [0,0,1,0,0,0],
          [0,0,0,1,0,0],
          [0,2,2,2,2,0],
          [0,0,0,0,0,0]]

test4 = do
  putStrLn "\n\nTest 4\n"
  putStrLn "All four should be true:"
  putStrLn $ "Board 6 (diag down) " ++ (show $ is_won' board6)
  putStrLn $ "Board 7 (diag up) " ++ (show $ is_won' board7)
  putStrLn $ "Board 8 (vert) " ++ (show $ is_won' board8)         
  putStrLn $ "Board 9 (horiz) " ++ (show $ is_won' board9)


main = do
  test1
  test2
  test3
  test4
