import Data.Maybe (isJust)

data Segment = Segment
  { a :: Char,
    b :: Char,
    c :: Char,
    d :: Char,
    e :: Char,
    f :: Char,
    g :: Char
  }

parseDisplay :: String -> ([String], [String])
parseDisplay s =
  let displays = words s
      sample = take 10 displays
      want = drop 11 displays
   in (sample, want)

findUnique :: ([String], [String]) -> Int
findUnique (sample, want) =
  let nums = map convertDisplay want
   in length $ filter isJust nums

convertDisplay :: String -> Maybe Int
convertDisplay s =
  case length s of
    2 -> Just 1
    4 -> Just 4
    3 -> Just 7
    7 -> Just 8
    _ -> Nothing

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let segments = map parseDisplay inputs
      uniques = map findUnique segments
  print $ sum uniques