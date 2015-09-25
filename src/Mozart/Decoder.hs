module Mozart.Decoder
    (
      decodeConfiguration
    ) where


import Data.ByteString.Lazy
import Data.Aeson (FromJSON, eitherDecode)
import Mozart.Types


instance FromJSON Configuration
instance FromJSON Component
instance FromJSON Meta


decodeConfiguration :: ByteString -> Either String Configuration
decodeConfiguration config = eitherDecode config
