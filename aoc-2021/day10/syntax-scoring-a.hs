import Data.Map (member, (!))
import qualified Data.Map
import Data.Maybe (fromJust, isJust)
import Debug.Trace (traceShow)

data SyntaxError
  = Incomplete Char
  | UnExpected Char
  deriving (Show)

pointTable :: Data.Map.Map Char Int
pointTable =
  Data.Map.fromList [(')', 3), (']', 57), ('}', 1197), ('>', 25137)]

matching = Data.Map.fromList [('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')]

parse :: String -> (Maybe SyntaxError, String)
parse "" = (Nothing, "")
parse (curr : rest)
  | member curr matching =
    let closing = matching ! curr
        (err, restr) = parse rest
     in case err of
          Just (Incomplete c) -> (err, restr)
          Just (UnExpected c) -> (err, restr)
          Nothing -> case restr of
            [] -> (Just (Incomplete closing), "")
            (x : rs) ->
              if x == closing
                then parse rs
                else (Just (UnExpected x), restr)
  | otherwise = (Nothing, (curr : rest))

isUnExpected x =
  case x of
    UnExpected c -> True
    _ -> False

main :: IO ()
main = do
  inputs <- fmap lines getContents
  let errs = map (fst . parse) inputs
      unexpecteds = map (\m -> if isJust m && (isUnExpected . fromJust) m then m else Nothing) errs
      points = map (\(Just (UnExpected c)) -> fromJust $ Data.Map.lookup c pointTable) $ filter isJust unexpecteds
  print $ sum points