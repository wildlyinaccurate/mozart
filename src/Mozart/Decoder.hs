module Mozart.Decoder
    (
      decodeConfiguration
    ) where


import Data.ByteString.Lazy
import Data.Aeson (FromJSON, eitherDecode)
import Mozart.Types


instance FromJSON Component


decodeConfiguration :: ByteString -> Either String Configuration
decodeConfiguration config = eitherDecode config
