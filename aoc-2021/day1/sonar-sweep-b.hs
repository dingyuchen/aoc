window :: [Integer] -> [Integer]
window nums =
  let a = (init . init) nums
      b = (init . tail) nums
      c = (tail . tail) nums
   in zipWith3 (\a b c -> a + b + c) a b c

sweep :: [Integer] -> Integer
sweep nums =
  let windows = window nums
      paired = zip (init windows) (tail windows)
      increment = map (\(a, b) -> a < b) paired
   in foldr (\a acc -> if a then acc + 1 else acc) 0 increment

main :: IO ()
main = do
  input <- getContents
  let nums = map read (lines input)
  print (sweep nums)