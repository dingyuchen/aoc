import Data.Map (Map, fromList, keys, lookup)
import Data.Maybe (catMaybes, isJust, mapMaybe)

makeMap :: [String] -> Map (Int, Int) Int
makeMap grid =
  fromList [((i, j), read [v]) | (i, row) <- zip [0 ..] grid, (j, v) <- zip [0 ..] row]

directions :: [(Int, Int)]
directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

neighbors :: Map (Int, Int) Int -> (Int, Int) -> [Int]
neighbors grid (x, y) = mapMaybe (\(dx, dy) -> Data.Map.lookup (x + dx, y + dy) grid) directions

isLowest :: Map (Int, Int) Int -> (Int, Int) -> Bool
isLowest grid (x, y) =
  case Data.Map.lookup (x, y) grid of
    Just v ->
      let ns = neighbors grid (x, y)
       in all (v <) ns
    Nothing -> False

main :: IO ()
main = do
  grid <- fmap lines getContents
  let heightMap = makeMap grid
      lowestPoints = filter (isLowest heightMap) (keys heightMap)
  print $ (sum . map (+ 1) . mapMaybe (`Data.Map.lookup` heightMap)) lowestPoints
