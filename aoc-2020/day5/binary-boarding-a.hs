{-# LANGUAGE LambdaCase #-}

import Data.Set (fromList)

data Part = Upper | Lower
  deriving (Show)

data Seat = Seat
  { row :: [Part],
    col :: [Part]
  }
  deriving (Show)

makeSeat :: String -> Seat
makeSeat ss =
  let parts =
        map
          ( \case
              'F' -> Lower
              'L' -> Lower
              'B' -> Upper
              'R' -> Upper
              _ -> error "invalid input"
          )
          ss
      (r, c) = splitAt 7 parts
   in Seat r c

getId s =
  let rowValue = round $ binSearch 0 127 (row s)
      colValue = round $ binSearch 0 7 (col s)
   in 8 * rowValue + colValue

binSearch lb _ [] = lb
binSearch lb ub (p : ps) =
  case p of
    Upper -> binSearch (fromIntegral . ceiling $ (lb + ub) / 2) ub ps
    Lower -> binSearch lb (fromIntegral . floor $ (lb + ub) / 2) ps

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let seats = map makeSeat inputs
      ids = map getId seats
  print $ maximum ids