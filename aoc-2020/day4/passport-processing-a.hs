{-# LANGUAGE OverloadedStrings #-}

import Data.Set (fromList, isSubsetOf)
import Data.Text (pack, splitOn, unpack)

getHeaders :: [String] -> [String]
getHeaders = map (unpack . head . splitOn ":" . pack)

required = fromList ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] --, "cid"]

checkHeaders :: [String] -> Bool
checkHeaders = isSubsetOf required . fromList

main :: IO ()
main = do
  input <- fmap (splitOn "\n\n" . pack) getContents
  let passports = map (getHeaders . words . unpack) input
  print (length (filter checkHeaders passports))
