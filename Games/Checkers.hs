 {-# LANGUAGE OverloadedStrings #-}
 import CodeWorld
 import Debug.Trace
 
 import qualified Data.Text as T
 main = activityOf start mouseh render_f

 type Model = ([(Point, Int, Int)],Int, Point)
 start = ([(((-4),(-4)),2,1),(((-4),(-2)),2,1), (((-3),(-3)),2,1), (((-2),(-4)),2,1), (((-2),(-2)),2,1), (((-1),(-3)),2,1), ((0,(-4)),2,1), ((0,(-2)),2,1), ((1,(-3)),2,1), ((2,(-4)),2,1), ((2,(-2)),2,1), ((3,(-3)),2,1),(((-3),3),1,1), (((-4),2),1,1), (((-3),1),1,1), (((-2),2),1,1), (((-1),3),1,1), (((-1),1),1,1), ((0,2),1,1), ((1,3),1,1), ((1,1),1,1), ((2,2),1,1), ((3,3),1,1), ((3,1),1,1)],2,(10,10))
 -- red is 1,  black is 2
 -- regular is 1,  king is 2
 -- ((Point, Color, Type of Piece),Turn, Last clicked)
 redpc = (colored red (solidCircle 0.8)) & (colored white (solidCircle 0.85))
 blackpc = (colored black (solidCircle 0.8)) & (colored white (solidCircle 0.85))
 pc ((x,y),a,b)
   | a == 1 && b == 1 = redpc
   | a == 2 && b == 1 = blackpc
   | a == 1 && b == 2 = (lettering "K") & redpc
   | a == 2 && b == 2 = (colored white (lettering "K")) & blackpc
 pts = [(x,y) | x <- [(-4.0)..3.0], y <- [(-4.0)..3.0]]
 bg = ((flatten ptsfinal)++ [translated (-1) (-1) (rectangle 16 16)])
 ptsblack [] _ = []
 ptsblack (x:xs) n = translated (x*2) (n*2) (colored black (solidRectangle 2 2)): ptsblack xs n
 ptsfinal =  [ptsblack [(-4),(-2)..2] n |n <- [(-4), (-2)..2]] ++ [ptsblack [(-3),(-1)..3] n | n <- [(-3),(-1)..3]]
 flatten [] = []
 flatten (x:xs) = x ++ (flatten xs)
 
 render_f:: Model -> Picture
 render_f ((a,x,y))
   | null [(b,c) | (b,c,e) <- a, c == 2] = (translated 0 0 (lettering "Red Wins!"))
   | null [(b,c) | (b,c,e) <- a, c == 1] = (translated 0 0 (lettering "Black Wins!"))
   | otherwise = pictures ([translated (b*2) (c*2) (pc ((b,c),d,e)) | ((b,c),d,e) <- a] ++ bg)

 dist (x,y) (x1,y1) = sqrt (((x-x1)^2) + ((y-y1)^2))
 clickedPt:: Point -> Point
 clickedPt (x,y) = head  [(a,b) | (a,b) <- pts, dist (a,b) (x/2,y/2) == (minimum [dist (a,b)(x/2,y/2) | (a,b) <- pts])]

 regpmove:: Point -> Int -> [Point]
 regpmove (x,y) n
  | n == 2 = [(a,b) | (a,b) <- [((x+1),(y+1)), ((x-1),(y+1))], a <= 3 && a >= (-4) && b <= 3 && b >= (-4)]
  | n == 1 = [(a,b) | (a,b) <- [((x+1),(y-1)), ((x-1),(y-1))], a <= 3 && a >= (-4) && b <= 3 && b >= (-4)]
  | otherwise = []

 kingpmove:: Point -> Int -> [Point]
 kingpmove (x,y) n = [(a,b) | (a,b) <- [((x+1),(y+1)), ((x-1),(y+1)), ((x-1), (y-1)),((x+1),(y-1))], a <= 3 && a >= (-4) && b <= 3 && b >= (-4)]

 help [x] = x
 isopen:: Model -> Point -> Bool
 isopen (a,b,(x,y)) (x1,y1)
  | take 1 [s | (q,r,s) <- a, q == (x,y)] == [1] && null[q|(q,r,s) <- a, q == (x1,y1)] = (x1,y1) `elem` (regpmove (x,y) (help[r | (q,r,s) <- a, q == (x,y)]))
  | take 1 [s | (q,r,s) <- a, q == (x,y)] == [2] && null[q| (q,r,s) <- a, q == (x1,y1)] = (x1,y1) `elem` (kingpmove (x,y) 1)
  | otherwise = False

 isjump:: Model -> Point -> Bool
 isjump (a,b,(x,y)) (x1,y1)
  | dist (x,y) (x1,y1) == (sqrt 8) = (jumppc (a,b,(x,y)) (x1,y1) (head [(r,s) | (q,r,s) <- a, q == (x,y)]) `elem` [q | (q,r,s) <- a])
  | otherwise = False
 
 jumppc:: Model -> Point -> (Int, Int) -> Point
 jumppc (a,b,(x,y)) (x1,y1) (u,v)
  | u == 1 && v == 1 = [c | c <- (regpmove (x,y) 1), d <- (regpmove (x1,y1) 2), c == d] !! 0
  | u == 1 && v == 2 = [c | c <- (kingpmove (x,y) 1), d <- (kingpmove (x1,y1) 1), c == d]!! 0
  | u == 2 && v == 1 = [c | c <- (regpmove (x,y) 2), d <- (regpmove (x1,y1) 1), c == d] !! 0
  | u == 2 && v == 2 = [c | c <- (kingpmove (x,y) 2), d <- (kingpmove (x1,y1) 2), c == d] !! 0
  where mover = if v == 1 then regpmove else kingpmove


{--
mover kind whatever 

mover 1 whatever = ...
mover 2 whatever = ...

--}

 king [] = []
 king (m@((a,as),b,c):ms)
  | b == 1 && as == (-4) = ((a,as),b,2): king ms
  | b == 2 && as == 3 = ((a,as),b,2): king ms
  | otherwise = m: king ms
 
 turn n
   | n == 1 = 2
   | n == 2 = 1
 
 mouseh:: Event -> Model -> Model
 mouseh (PointerPress (x,y)) m@(a,b,c@(x1,y1))
   | x < (-8) && x > 6 && y < (-8) && y > 6 = m
   | help5 (a,b,c) (clickedPt (x,y)) && help4 (a,b,c) (clickedPt (x,y)) && isjump (a,b,c) (clickedPt(x,y)) && (clickedPt(x,y) /= c) = ((king ([(q,r,s) | (q,r,s) <- a, q /= (help2 (a,b,c) (x,y)) && q /= (help3 (a,b,c) (x,y))] ++ [(clickedPt(x,y),r,s) | (q,r,s) <- a, q == (help3 (a,b,c) (x,y))])),(turn b),(10,10))
   | help5 (a,b,c) (clickedPt (x,y)) && isopen (a,b,c) (clickedPt(x,y)) && (clickedPt(x,y) /= c) = (king(([(clickedPt(x,y),r,s) | (q,r,s) <- a, q == c] ++[(q,r,s) | (q,r,s) <- a, q /= c])),(turn b), (10,10))
   | help5 (a,b,c) (clickedPt (x,y)) && clickedPt(x,y) `elem` [q | (q,r,s) <- a] = (a,b,clickedPt (x,y))
   | otherwise = m
 mouseh _ a = a

 help2 (a,b,c@(x1,y1)) (x,y)
   | [r | (q,r,s) <- a, q == ([(jumppc (a,b,c) (clickedPt(x,y)) (r,s))|  (q,r,s) <- a, q == (x1,y1)]!!0)] /= [r | (q,r,s) <- a, q == (x1,y1)] = ([(jumppc (a,b,c) (clickedPt(x,y)) (r,s))|  (q,r,s) <- a, q == (x1,y1)]!!0)
   | otherwise = (10,10)

 help3 (a,b,c@(x1,y1)) (x,y)
   | help2 (a,b,(x1,y1)) (x,y) == (10,10) = (10,10)
   | otherwise = (x1,y1)
 
 help4 (a,b,c@(x1,y1)) (x,y) = null [q | (q,r,s) <- a, q == (x,y)]

 help5 (a,b,c@(x1,y1)) (x,y) = [r |(q,r,s) <- a, q == (x,y) ||q == (x1,y1)] == [b]

