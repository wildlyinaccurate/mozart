{-# LANGUAGE DeriveGeneric #-}

module Mozart.Envelope where

import Data.Aeson (FromJSON, eitherDecode)
import qualified Data.ByteString.Lazy as BL
import GHC.Generics (Generic)


data Envelope = Envelope
    { head :: [String]
    , bodyInline :: String
    , bodyLast :: [String]
    } deriving (Generic)

instance FromJSON Envelope


decodeEnvelope :: BL.ByteString -> Either String Envelope
decodeEnvelope = eitherDecode
