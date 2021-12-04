{-# LANGUAGE OverloadedStrings #-}

import Data.List (sort)
import Data.Map (fromList, lookup, (!))
import Data.Text (pack, splitOn, unpack)
import Debug.Trace (trace)

debug = flip trace

data Grid = Grid
  { cells :: [[Int]],
    seen :: [Int]
  }
  deriving (Show)

check :: [(Int, Int)] -> Int -> Bool
check seens rowSize =
  let transp = [(j, i) | (i, j) <- seens]
      checkRow g i =
        let line = filter (\(x, y) -> x == i) g
         in sort (map snd line) == [0 .. rowSize] -- `debug` show [0 .. rowSize]
      checkGrid g = any (checkRow g) [0 .. rowSize]
   in checkGrid seens || checkGrid transp

-- makeMap :: (Num a, Num b, Enum a, Enum b) => Grid -> Data.IntMap.Internal.IntMap (a, b)
makeMap g = fromList [(v, (i, j)) | (i, row) <- zip [0 ..] (cells g), (j, v) <- zip [0 ..] row]

isWinner :: Grid -> Int -> Bool
isWinner g i =
  let mapping = makeMap g
      seen_indices = map (`Data.Map.lookup` mapping) (i : seen g) -- `debug` show mapping
      seenReduced =
        foldr
          ( \a acc -> case a of
              Just coord -> coord : acc
              Nothing -> acc
          )
          []
          seen_indices
   in check seenReduced (length (cells g) - 1)

play :: Grid -> Int -> (Bool, Grid)
play grid i = (isWinner grid i, Grid (cells grid) (i : seen grid))

board :: [(Bool, Grid)] -> Grid
board = snd . (!! 0) . filter fst

playBingo :: [Grid] -> [Int] -> Int
playBingo grids [] = 0
playBingo grids (n : ins) =
  let res = map (`play` n) grids -- `debug` show grids
   in if any fst res
        then
          let winner = board res
           in calcScore winner n
        else
          let nextState = map snd res
           in playBingo nextState ins

calcScore :: Grid -> Int -> Int
calcScore g i =
  let unseen = filter (\n -> n `notElem` seen g) [v | row <- cells g, v <- row]
   in sum unseen * i

makeGrid :: [String] -> Grid
makeGrid ss = Grid (map (map read . words) ss) []

main :: IO ()
main = do
  stream <- getLine
  _ <- getLine
  inputs <- getContents
  let grids = map (makeGrid . lines . unpack) (splitOn "\n\n" (pack inputs))
      inStream = map (read . unpack) (splitOn "," (pack stream))
      score = playBingo grids inStream
  print score