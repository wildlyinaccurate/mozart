module Mozart.Decoder
    (
      decodeConfiguration
    , decodeEnvelope
    ) where


import Data.ByteString.Lazy
import Data.Aeson (FromJSON, eitherDecode)
import Mozart.Types


instance FromJSON Configuration
instance FromJSON Component
instance FromJSON Meta
instance FromJSON Envelope


decodeConfiguration :: ByteString -> Either String Configuration
decodeConfiguration = eitherDecode


decodeEnvelope :: ByteString -> Either String Envelope
decodeEnvelope = eitherDecode
