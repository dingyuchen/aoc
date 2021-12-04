slide :: Int -> Int -> [String] -> Int
slide i j map =
  let helper pos [] acc = acc
      helper pos map@(row : rest) acc =
        let width = length row
            new_pos = (pos + j) `mod` width
         in case row !! pos of
              '.' -> helper new_pos (drop i map) acc
              '#' -> helper new_pos (drop i map) (acc + 1)
              _ -> error "invalid"
   in helper 0 map 0

main :: IO ()
main = do
  input <- getContents
  let inputRows = lines input
      slopes = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]
      trees = map (\(i, j) -> slide i j inputRows) slopes
      countTrees = product trees
  print countTrees