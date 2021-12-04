import Data.Text (pack, split, unpack)

checkValidity :: String -> Bool
checkValidity str =
  let lex = words str
      constraints = split (== '-') (pack (lex !! 0))
      [lb, ub] = map (read . unpack) constraints
      [letter, _] = lex !! 1
      pw = lex !! 2
      freqCount = foldr (\a acc -> if a == letter then acc + 1 else acc) 0 pw
   in lb <= freqCount && freqCount <= ub

main :: IO ()
main = do
  input <- getContents
  let inputs = lines input
      valids = map checkValidity inputs
  print ((length . filter (\x -> x)) valids)