module Mozart.Composition
    (
      compose
    ) where

import Data.ByteString.Lazy (ByteString)
import Mozart.Decoder
import Mozart.Types


compose :: ByteString -> String
compose config = do
    case decodeConfiguration config of
        Left err ->
            "Invalid Configuration:" ++ err

        Right components ->
            foldl1 combineComponents $ map renderComponent components


renderComponent :: Component -> String
renderComponent cmp = "<rendered " ++ name cmp ++ "@" ++ version cmp ++ res ++ ">"
    where res = fetchComponent (source cmp) (parameters cmp)


fetchComponent :: String -> [Parameter] -> String
fetchComponent source parameters = show parameters


combineComponents :: String -> String -> String
combineComponents = (++) . (++ "\n")
