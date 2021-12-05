{-# LANGUAGE LambdaCase #-}

import Data.Set (fromList, member, notMember)

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
  let rowValue = binSearch 1 126 (row s)
      colValue = binSearch 0 7 (col s)
   in rowValue * 8 + colValue

binSearch :: Int -> Int -> [Part] -> Int
binSearch lb _ [] = lb
binSearch lb ub (p : ps) =
  case p of
    Upper -> binSearch (ceiling $ toRational (lb + ub) / 2) ub ps
    Lower -> binSearch lb (floor $ toRational (lb + ub) / 2) ps

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let seats = map makeSeat inputs
      ids = fromList $ map getId seats
      allPossible = [r * 8 + c | r <- [1 .. 126], c <- [0 .. 7]]
      leftovers = filter (`notMember` ids) allPossible
  print $ filter (\x -> (x + 1) `member` ids && (x - 1) `member` ids) leftovers