{-# LANGUAGE OverloadedStrings #-}

import Data.Function (fix)
import Data.Text (pack, splitOn, unpack)
import Debug.Trace (traceShow)

data School = School
  { fish :: [Int],
    baby :: (Int, Int)
  }

makeSchool :: [Int] -> School
makeSchool fs =
  let fish = map (count fs) [0 .. 6]
   in School fish (0, 0)

count xs n = length $ filter (== n) xs

simulate :: School -> School
simulate sch =
  let (birth : rest) = fish sch
      (adult, adol) = baby sch
   in School (rest ++ [birth + adult]) (adol, birth)

simulateN :: Int -> School -> School
simulateN i =
  foldl (.) id (replicate i simulate)

schSize :: School -> Int
schSize sch =
  let (a, b) = baby sch
   in sum (fish sch) + a + b

main :: IO ()
main = do
  input <- getLine
  let inputs = splitOn "," $ pack input
      fishes = map (read . unpack) inputs
      school = makeSchool fishes
  print $ schSize $ simulateN 256 school