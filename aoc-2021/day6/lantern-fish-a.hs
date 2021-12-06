{-# LANGUAGE OverloadedStrings #-}

import Data.Text (pack, splitOn, unpack)

newtype Fish = Fish [Int]

fish :: Int -> Fish
fish i = Fish $ reverse [0 .. i] ++ cycle [6, 5 .. 0]

babyFish :: Fish
babyFish = Fish $ [8, 7] ++ cycle [6, 5 .. 0]

simulate :: [Fish] -> [Fish]
simulate fishes =
  let newFishes = map (const babyFish) $ filter (\(Fish l) -> head l == 0) fishes
   in map (\(Fish l) -> Fish $ tail l) fishes ++ newFishes

simulateN :: Int -> [Fish] -> [Fish]
simulateN i = foldr (.) id (replicate i simulate)

main :: IO ()
main = do
  input <- getLine
  let inputs = splitOn "," $ pack input
      fishes = map (fish . read . unpack) inputs
  print $ length $ simulateN 80 fishes