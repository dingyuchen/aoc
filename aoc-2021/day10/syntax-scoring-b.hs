import Data.List (sort)
import Data.Map (member, (!))
import qualified Data.Map
import Data.Maybe (fromJust, isJust)
import Debug.Trace (traceShow)

data SyntaxError
  = Incomplete String
  | UnExpected Char
  deriving (Show)

pointTable :: Data.Map.Map Char Int
pointTable =
  Data.Map.fromList [(')', 1), (']', 2), ('}', 3), ('>', 4)]

matching = Data.Map.fromList [('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')]

parse :: String -> (Maybe SyntaxError, String)
parse "" = (Nothing, "")
parse txt@(curr : rest)
  | member curr matching =
    let closing = matching ! curr
        (err, restr) = parse rest
     in case err of
          Just (Incomplete s) -> (Just (Incomplete (s ++ [closing])), restr)
          Just (UnExpected c) -> (err, restr)
          Nothing -> case restr of
            [] -> (Just (Incomplete [closing]), "")
            (x : rs) ->
              if x == closing
                then parse rs
                else (Just (UnExpected x), restr)
  | otherwise = (Nothing, txt)

isIncomplete x =
  case x of
    Incomplete c -> True
    _ -> False

unbox (Just (Incomplete s)) = s
unbox _ = error "Expecting incomplete string only"

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let errs = map (fst . parse) inputs
      incompletes = filter isJust $ map (\m -> if isJust m && (isIncomplete . fromJust) m then m else Nothing) errs
      points = sort $ map (foldl (\acc a -> 5 * acc + pointTable ! a) 0 . unbox) incompletes
  print $ points !! ((length points -1) `div` 2)