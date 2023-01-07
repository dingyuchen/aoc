{-# LANGUAGE ScopedTypeVariables #-}

import qualified Data.Map

neighboring :: [(Integer, Integer)]
neighboring = [(1, 0), (1, 1), (0, 1), (-1, 0), (-1, -1), (0, -1), (1, -1), (-1, 1)]

simulate grid =
  let step1 = Data.Map.map (+ 1) grid
      flashers = Data.Map.filter (> 9) step1
      spread (octs, newFlashers) =
        let nextState = foldl (flip (Data.Map.adjust (+ 1))) octs newFlashers
         in (nextState,)
   in step1

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let dd :: [[Integer]] = map (map (\x -> read [x])) inputs
      grid = Data.Map.fromList [((i, j), v) | (i, row) <- zip [0 ..] dd, (j, v) <- zip [0 ..] row]
  print grid
