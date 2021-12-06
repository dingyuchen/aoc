{-# LANGUAGE OverloadedStrings #-}

import Data.Set (fromList, size, union)
import Data.Text (pack, splitOn, unpack)

collect ss = foldl1 union ss

main :: IO ()
main = do
  content <- getContents
  let groups = splitOn "\n\n" $ pack content
      values = map (size . collect . map fromList . lines . unpack) groups
  print $ sum values