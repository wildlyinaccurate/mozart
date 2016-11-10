module Mozart.Composition
    (
      compose
    ) where

import Control.Concurrent.Async
import Data.ByteString.Lazy (ByteString)
import Data.List

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
            envelopes <- mapConcurrently fetchComponent (contents config)
            return $ renderComponents envelopes


renderComponents :: [Envelope] -> String
renderComponents envelopes = do
    let heads = combineComponents Mz.head envelopes
    let bodyInlines = map bodyInline envelopes
    let bodyLasts = combineComponents bodyLast envelopes

    concatMap (++ "\n") (concat [heads, bodyInlines, bodyLasts])


combineComponents :: (Envelope -> [String]) -> [Envelope] -> [String]
combineComponents f envelopes = nub $ concat $ map f envelopes


fetchComponent :: Component -> IO Envelope
fetchComponent cmp = do
    let uri = endpoint cmp
    res <- simpleHTTP (makeLazyRequest uri)
    body <- getResponseBody res

    case decodeEnvelope body of
        Left _ ->
            error $ "Invalid response from " ++ uri

        Right envelope ->
            return envelope


makeLazyRequest :: String -> Request ByteString
makeLazyRequest url =
    case parseURI url of
        Nothing -> error $ "Invalid component endpoint: " ++ url
        Just uri -> mkRequest GET uri
