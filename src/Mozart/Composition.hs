module Mozart.Composition
    (
      compose
    ) where

import Data.ByteString.Lazy (ByteString)
import Mozart.Decoder
import Mozart.Types as Mz


compose :: ByteString -> String
compose sourceConfig = do
    case decodeConfiguration sourceConfig of
        Left err ->
            "Invalid Configuration:" ++ err

        Right config ->
            foldl1 combineComponents $ map renderComponent (components config)


renderComponent :: Component -> String
renderComponent = bodyInline . fetchComponent


fetchComponent :: Component -> Envelope
fetchComponent cmp = do
    Envelope [] bodyInline []
  where bodyInline = "<rendered " ++ Mz.id cmp ++ "@" ++ version cmp ++ ">"


combineComponents :: String -> String -> String
combineComponents = (++) . (++ "\n")
