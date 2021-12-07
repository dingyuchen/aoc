{-# LANGUAGE OverloadedStrings #-}

import Data.List (sort)
import Data.Text (pack, splitOn, unpack)

fuelUse :: [Integer] -> Integer
fuelUse pos =
  let mid = length pos `div` 2
      smaller = take mid pos
      larger = take mid (reverse pos)
   in sum larger - sum smaller

main :: IO ()
main = do
  line <- getLine
  let positions = map (read . unpack) $ splitOn "," (pack line)
  print $ fuelUse (sort positions)