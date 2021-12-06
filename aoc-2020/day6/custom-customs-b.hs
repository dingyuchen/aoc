{-# LANGUAGE OverloadedStrings #-}

import Data.Set (fromList, intersection, size, union)
import Data.Text (pack, splitOn, unpack)

collect = foldl1 intersection

main :: IO ()
main = do
  content <- getContents
  let groups = splitOn "\n\n" $ pack content
      values = map (size . collect . map fromList . lines . unpack) groups
  print $ sum values