import qualified Data.Bifunctor
import Data.List (nub, sort, sortOn)
import Data.Map (Map, fromList, keys, lookup, (!))
import Data.Maybe (catMaybes, fromJust, isJust, mapMaybe)
import Data.Ord (comparing)
import Data.Set (Set, empty, fromList, member, union, unions)

type Grid = Map (Int, Int) Int

makeMap :: [String] -> Map (Int, Int) Int
makeMap grid =
  Data.Map.fromList [((i, j), read [v]) | (i, row) <- zip [0 ..] grid, (j, v) <- zip [0 ..] row]

directions :: [(Int, Int)]
directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

neighbors :: Map (Int, Int) Int -> (Int, Int) -> [((Int, Int), Int)]
neighbors grid (x, y) =
  let ns =
        map
          ( \(dx, dy) ->
              let (nx, ny) = (x + dx, y + dy)
               in ((nx, ny), Data.Map.lookup (nx, ny) grid)
          )
          directions
   in map (Data.Bifunctor.second fromJust) $ filter (isJust . snd) ns

isLowest :: Map (Int, Int) Int -> (Int, Int) -> Bool
isLowest grid (x, y) =
  case Data.Map.lookup (x, y) grid of
    Just v ->
      let ns = neighbors grid (x, y)
       in all ((v <) . snd) ns
    Nothing -> False

dfs :: (Int, Int) -> Set (Int, Int) -> Grid -> Set (Int, Int)
dfs curr seen heights =
  if member curr seen
    then seen
    else
      let ns = neighbors heights curr
          value = heights ! curr
          uphill = map fst $ filter (\(coord, v) -> v /= 9 && value < v) ns
       in foldl (\basin nb -> basin `union` dfs nb basin heights) (seen `union` Data.Set.fromList [curr]) uphill

main :: IO ()
main = do
  grid <- fmap lines getContents
  let heightMap = makeMap grid
      lowestPoints = filter (isLowest heightMap) (keys heightMap)
      basins = nub $ map (\coord -> dfs coord Data.Set.empty heightMap) lowestPoints
      bs = reverse . sort $ map length basins
  print $ product $ take 3 bs
