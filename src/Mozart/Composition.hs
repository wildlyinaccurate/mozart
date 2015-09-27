module Mozart.Composition
    (
      compose
    ) where

import Data.ByteString.Lazy (ByteString)
import Mozart.Decoder
import Mozart.Types as Mz

import Network.HTTP
import Network.URI (parseURI)


compose :: ByteString -> IO String
compose sourceConfig = do
    case decodeConfiguration sourceConfig of
        Left err ->
            error $ "Invalid Configuration: " ++ err

        Right config -> do
            envelopes <- mapM fetchComponent (components config)
            return $ renderComponents envelopes


combineComponents :: String -> String -> String
combineComponents = (++) . (++ "\n")


renderComponents :: [Envelope] -> String
renderComponents envelopes = do
    let heads = map (concat . Mz.head) envelopes
    let contents = map bodyInline envelopes
    let bodyLasts = map (concat . bodyLast) envelopes

    concatMap (++ "\n") (concat [heads, contents, bodyLasts])


fetchComponent :: Component -> IO Envelope
fetchComponent cmp = do
    let uri = endpoint cmp
    res <- simpleHTTP (makeLazyRequest uri)
    body <- getResponseBody res

    case decodeEnvelope body of
        Left err ->
            error $ "Invalid response from " ++ uri

        Right envelope ->
            return envelope


makeLazyRequest :: String -> Request ByteString
makeLazyRequest url =
    case parseURI url of
        Nothing -> error $ "Invalid component endpoint: " ++ url
        Just uri -> mkRequest GET uri
