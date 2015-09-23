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
            foldl1 (++) $ map renderComponent components


renderComponent :: Component -> String
renderComponent cmp = "<rendered " ++ name cmp ++ "@" ++ version cmp ++ ">"
