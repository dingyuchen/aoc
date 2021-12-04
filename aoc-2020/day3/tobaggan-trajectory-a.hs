slide :: Int -> Int -> [String] -> Int
slide i j map =
  let helper pos [] acc = acc
      helper pos (row : rest) acc =
        let width = length row
            new_pos = (pos + j) `mod` width
         in case row !! pos of
              '.' -> helper new_pos rest acc
              '#' -> helper new_pos rest (acc + 1)
              _ -> error "invalid"
   in helper 0 map 0

main :: IO ()
main = do
  input <- getContents
  let inputRows = lines input
      countTrees = slide 1 3 inputRows
  print countTrees