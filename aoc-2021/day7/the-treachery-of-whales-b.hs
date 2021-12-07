{-# LANGUAGE OverloadedStrings #-}

import Data.List (sort)
import Data.Text (pack, splitOn, unpack)

fuelCost :: [Integer] -> Integer -> Integer
fuelCost pos x =
  let dist = map (abs . (x -)) pos
   in sum $ map (\n -> n * (n + 1) `div` 2) dist

fuelUse :: [Integer] -> Integer
fuelUse pos =
  let smallest = minimum pos
      largest = maximum pos
   in minimum $ map (fuelCost pos) [smallest .. largest]

main :: IO ()
main = do
  line <- getLine
  let positions = map (read . unpack) $ splitOn "," (pack line)
  print $ fuelUse positions