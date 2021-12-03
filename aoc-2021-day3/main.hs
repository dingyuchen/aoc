{-# LANGUAGE OverloadedStrings #-}

import Control.Arrow ((&&&))
import Data.List (transpose)
import qualified Data.Map as Data.Map.Internal

data Bit = One | Zero
  deriving (Eq, Show)

mkBit :: Char -> Bit
mkBit c = case c of
  '1' -> One
  '0' -> Zero
  _ -> error "Not valid input"

mkbits :: String -> [Bit]
mkbits = map mkBit

countFreq :: (Int -> Int -> Bit) -> [Bit] -> Bit
countFreq cmp b =
  let counter [] (zeros, ones) = cmp zeros ones
      counter (b : bs) (zeros, ones) =
        counter
          bs
          ( case b of
              Zero -> (zeros + 1, ones)
              One -> (zeros, ones + 1)
          )
   in counter b (0, 0)

oxyGenBit :: [Bit] -> Bit
oxyGenBit = countFreq (\z o -> if o >= z then One else Zero)

co2ScrubBit :: [Bit] -> Bit
co2ScrubBit = countFreq (\z o -> if o >= z then Zero else One)

diagnose :: ([Bit] -> Bit) -> Int -> [[Bit]] -> [Bit]
diagnose _ i [s] = drop i s
diagnose sys i ss =
  if i >= length (head ss)
    then []
    else
      let workingSet = map (!! i) ss
          thisBit = sys workingSet
       in thisBit : diagnose sys (i + 1) (filter (\bitS -> bitS !! i == thisBit) ss)

toDec :: [Bit] -> Integer
toDec =
  foldl
    ( \acc a ->
        ( case a of
            One -> 1
            Zero -> 0
        )
          + 2 * acc
    )
    0

toChar :: Bit -> String
toChar a =
  case a of
    One -> "1"
    Zero -> "0"

toString = foldl (\acc a -> acc ++ toChar a) ""

main :: IO ()
main = do
  input <- getContents
  let inputLines = lines input
      inputLineBits = map mkbits inputLines
      oxy = diagnose oxyGenBit 0 inputLineBits
      co2 = diagnose co2ScrubBit 0 inputLineBits
  print (map toString inputLineBits)
  print (toString oxy)
  print (toString co2)
  print (toDec oxy * toDec co2)
