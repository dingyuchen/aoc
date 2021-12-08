import Data.List (foldl', intercalate, sort, sortOn, (\\))
import Data.Map (Map, findWithDefault, fromList, lookup)
import Data.Set (isSubsetOf)
import qualified Data.Set
import Debug.Trace (traceShow)

type Wiring = Map String Char

parseDisplay :: String -> ([String], [String])
parseDisplay s =
  let displays = words s
      sample = map sort $ take 10 displays
      want = map sort $ drop 11 displays
   in (sortOn length sample, want)

solve :: ([String], [String]) -> Int
solve (sample, want) =
  let wiring = deriveWiring sample
   in read $ intercalate "" $ map (\n -> [findWithDefault '0' n wiring]) want

deriveWiring :: [String] -> Wiring
deriveWiring inputs =
  let eight = last inputs
      one = head inputs
      seven = inputs !! 1
      four = inputs !! 2
      smallL = (eight \\ four) \\ seven
      fiveChars = filter ((== 5) . length) inputs
      sixChars = filter ((== 6) . length) inputs
      two = head $ filter (subset smallL) fiveChars
      nine = head $ filter (not . subset smallL) sixChars
      threeOrFive = filter (/= two) fiveChars
      zeroOrSix = filter (/= nine) sixChars
      (zero, six) = foldl' (\(z, s) a -> if subset one a then (a, s) else (z, a)) ("a", "a") zeroOrSix
      -- (three, five) = span (subset one) fiveChars
      (three, five) = foldl' (\(z, s) a -> if subset one a then (a, s) else (z, a)) ("a", "a") threeOrFive
   in fromList [(one, '1'), (two, '2'), (three, '3'), (four, '4'), (five, '5'), (six, '6'), (seven, '7'), (eight, '8'), (nine, '9'), (zero, '0')]

subset :: [Char] -> [Char] -> Bool
subset x xs = isSubsetOf (Data.Set.fromList x) (Data.Set.fromList xs)

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let segments = map parseDisplay inputs
      outputs = map solve segments
  print $ sum outputs