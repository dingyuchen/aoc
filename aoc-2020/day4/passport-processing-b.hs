{-# LANGUAGE OverloadedStrings #-}

import Data.Char (isDigit, isHexDigit, toLower)
import Data.Map (Map, fromList)
import Data.Set (fromList, isSubsetOf)
import Data.Text (pack, splitOn, unpack)

getPairs :: [String] -> [(String, String)]
getPairs = map ((\[k, v] -> (unpack k, unpack v)) . splitOn ":" . pack)

required = Data.Set.fromList ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] --, "cid"]

checkHeaders :: [String] -> Bool
checkHeaders = isSubsetOf required . Data.Set.fromList

validate :: [(String, String)] -> Bool
validate pp = checkHeaders (map fst pp) && all checkValue pp

lastN n = foldr (\a acc -> if length acc < n then a : acc else acc) []

checkValue :: (String, String) -> Bool
checkValue (key, value) = case key of
  "byr" ->
    let yr = read value
     in 1920 <= yr && yr <= 2002
  "iyr" ->
    let yr = read value
     in 2010 <= yr && yr <= 2020
  "eyr" ->
    let yr = read value
     in 2020 <= yr && yr <= 2030
  "hgt" ->
    let unit = lastN 2 value
        height = read (takeWhile isDigit value)
     in case unit of
          "in" -> 59 <= height && height <= 76
          "cm" -> 150 <= height && height <= 193
          _ -> False
  "hcl" -> (take 1 value == "#") && all isHexDigit (drop 1 value)
  "ecl" -> value `elem` ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  "pid" -> length value == 9 && all isDigit value
  "cid" -> True
  _ -> error "unknown header"

main :: IO ()
main = do
  input <- fmap (splitOn "\n\n" . pack) getContents
  let passports = map (getPairs . words . unpack) input
  --   print passports
  print (length (filter validate passports))
