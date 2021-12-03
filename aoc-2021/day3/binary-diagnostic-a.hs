{-# LANGUAGE OverloadedStrings #-}

import Data.List (transpose)

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

findMax = countFreq (\z o -> if z > o then Zero else One)

findMin = countFreq (\z o -> if z > o then One else Zero)

diagnose :: ([Bit] -> Bit) -> [[Bit]] -> [Bit]
diagnose sys ss =
  let workingSet = transpose ss
   in map sys workingSet

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
      gamma = diagnose findMax inputLineBits
      epsilon = diagnose findMin inputLineBits
  print (toString gamma)
  print (toString epsilon)
  print (toDec gamma * toDec epsilon)
