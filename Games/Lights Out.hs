  {-# LANGUAGE OverloadedStrings #-}
  import CodeWorld
  import qualified Data.Text as T
  main = activityOf start handler render_f
  bg = [translated (x*4) (y*4) (circle 1.9) | (x,y) <- pts]
  pts = [(x,y) | x <- [(-2)..2], y <- [(-2)..2]]
  
  dist (x,y) (x1,y1) = sqrt (((x-x1)^2) + ((y-y1)^2))
  clickedPt (x,y) = head [(a,b) | (a,b) <- pts, dist (a,b) (x,y) == (minimum [dist (a,b)(x,y) | (a,b) <- pts])]
  
  help a (x,y) = [(b,c) | (b,c) <- a, (b,c) /= (x,y)]
  type Model = [Point]
  flipOne :: Model -> Point -> Model
  flipOne a (x,y) 
    | (x,y) `elem` a = help a (x,y)
    | otherwise = a ++ [(x,y)]
  
  render_f:: Model -> Picture
  render_f [] = (translated 0 0 (lettering "You Win!"))
  render_f a = pictures ([translated (x*4) (y*4) (colored blue (solidCircle 1.9)) | (x,y) <- a] ++ bg)

  start :: Model
  start = [(1,1)]
  
  flipAll :: Model -> [Point] -> Model
  flipAll a [] = a
  flipAll a (x:xs) = flipAll (flipOne a x) xs
  
  updateclick:: Model -> Maybe Point -> Model
  updateclick a (Just (x,y)) = flipAll a ([(r,s) | (r,s) <- [(x,(y+1)), (x-1,y), (x,y-1), (x+1,y)], r `elem` [(-2)..2] && s `elem` [(-2)..2]] ++ [(x,y)])

  handler :: Event -> Model -> Model
  handler (PointerPress (x,y)) a = updateclick a (Just(clickedPt (x/4, y/4)))
  handler _ a = a
  
  

