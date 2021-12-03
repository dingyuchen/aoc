{-# LANGUAGE OverloadedStrings #-}

import Data.Text (pack, splitOn, unpack)

data Move = Vertical Integer | Horizontal Integer

parse :: String -> Move
parse inputStr =
  let args = splitOn " " (pack inputStr)
      (dir, magnitude) = (head args, head $ tail args)
      mag = (read . unpack) magnitude
   in case dir of
        "forward" -> Horizontal mag
        "up" -> Vertical (- mag)
        "down" -> Vertical mag
        _ -> Horizontal 0

aggregate :: [Move] -> Integer
aggregate moves =
  let helper [] aim pos depth = (aim, pos, depth)
      helper (m : ms) aim pos depth =
        let (newAim, newPos, newDepth) = case m of
              Horizontal x -> (aim, pos + x, depth + aim * x)
              Vertical x -> (aim + x, pos, depth)
         in helper ms newAim newPos newDepth
      (aim, pos, depth) = helper moves 0 0 0
   in pos * depth

main :: IO ()
main = do
  input <- getContents
  let inputLines = lines input
      moves = map parse inputLines
  print (aggregate moves)
