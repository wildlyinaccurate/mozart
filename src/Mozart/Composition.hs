module Mozart.Composition (compose) where

import Control.Concurrent.Async
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as CL
import Data.List
import Data.String.Utils (replace)

import Mozart.Configuration
import Mozart.Envelope as E

import Network.HTTP
import Network.URI (parseURI)


compose :: BL.ByteString -> BL.ByteString -> IO String
compose sourceConfig template = do
    case decodeConfiguration sourceConfig of
        Left err ->
            error $ "Invalid Configuration: " ++ err

        Right config -> do
            envelopes <- mapConcurrently fetchComponent (contents config)
            return $ renderComponents template envelopes


renderComponents :: BL.ByteString -> [Envelope] -> String
renderComponents template envelopes = replace "{{head}}" heads (replace "{{bodyInline}}" bodyInlines (replace "{{bodyLast}}" bodyLasts $ CL.unpack template))
    where
        heads = concatMap (++ "") $ combineComponents E.head envelopes
        bodyInlines = concatMap (++ "") $ map bodyInline envelopes
        bodyLasts = concatMap (++ "") $ combineComponents bodyLast envelopes


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


makeLazyRequest :: String -> Request BL.ByteString
makeLazyRequest url =
    case parseURI url of
        Nothing -> error $ "Invalid component endpoint: " ++ url
        Just uri -> mkRequest GET uri
