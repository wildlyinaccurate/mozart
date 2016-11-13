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
renderComponents envelopes = concatMap (++ "\n") (concat [heads, bodyInlines, bodyLasts])
    where
        heads = combineComponents Mz.head envelopes
        bodyInlines = map bodyInline envelopes
        bodyLasts = combineComponents bodyLast envelopes



combineComponents :: (Envelope -> [String]) -> [Envelope] -> [String]
combineComponents f envelopes = nub $ concat $ map f envelopes


fetchComponent :: Component -> IO Envelope
fetchComponent cmp =
    let uri = endpoint cmp
    in do
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
