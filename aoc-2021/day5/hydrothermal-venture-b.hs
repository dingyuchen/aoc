{-# LANGUAGE OverloadedStrings #-}

import Data.Char (isDigit, isHexDigit, toLower)
import Data.Set (Set, empty, fromList, intersection, isSubsetOf, size, union)
import Data.Text (pack, splitOn, unpack)
import Debug.Trace

getCells :: [String] -> Set (Int, Int)
getCells [start, _, end] =
  let [x1, y1] = map (read . unpack) $ splitOn "," $ pack start
      [x2, y2] = map (read . unpack) $ splitOn "," $ pack end
   in drawLine (x1, y1) (x2, y2)
getCells _ = empty

drawLine :: (Int, Int) -> (Int, Int) -> Set (Int, Int)
drawLine (x1, y1) (x2, y2) =
  let (xstart, xend) = (min x1 x2, max x1 x2)
      (ystart, yend) = (min y1 y2, max y1 y2)
      x' = if xstart == x1 then [xstart .. xend] else reverse [xstart .. xend]
      y' = if ystart == y1 then [ystart .. yend] else reverse [ystart .. yend]
      xs = if length x' == 1 then repeat xstart else x'
      ys = if length y' == 1 then repeat ystart else y'
      smoke = zip xs ys
   in fromList smoke

findOverlap :: (Ord a, Show a) => [Set a] -> (Set a, Set a)
findOverlap allSets =
  let finder (total, overlaps) curr = (total `union` curr, (total `intersection` curr) `union` overlaps)
   in foldl finder (head allSets, empty) (tail allSets)

main :: IO ()
main = do
  input <- fmap lines getContents
  let smokeLines = map (getCells . words) input
      smokeCells = filter (not . null) smokeLines
      (_, overlaps) = findOverlap smokeCells
  --   print overlaps
  print $ length overlaps
