import Data.Text (pack, split, unpack)

checkValidity :: String -> Bool
checkValidity str =
  let lex = words str
      constraints = split (== '-') (pack (lex !! 0))
      [posX, posY] = map ((\x -> x - 1) . read . unpack) constraints
      [letter, _] = lex !! 1
      pw = lex !! 2
   in (pw !! posX == letter) /= (pw !! posY == letter)

main :: IO ()
main = do
  input <- getContents
  let inputs = lines input
      valids = map checkValidity inputs
  print ((length . filter (\x -> x)) valids)