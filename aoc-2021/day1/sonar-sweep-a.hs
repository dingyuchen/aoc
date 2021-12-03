sweep :: [Integer] -> Integer
sweep nums =
  let paired = zip (init nums) (tail nums)
      increment = map (\(a, b) -> a < b) paired
   in foldr (\a acc -> if a then acc + 1 else acc) 0 increment

main :: IO ()
main = do
  input <- getContents
  let nums = map read (lines input)
  print (sweep nums)