{-# LANGUAGE DeriveGeneric #-}

module Mozart.Configuration where

import Data.Aeson (FromJSON, eitherDecode)
import qualified Data.ByteString.Lazy as BL
import GHC.Generics (Generic)


data Configuration = Configuration
    { contents :: [Component]
    } deriving (Generic)

instance FromJSON Configuration


data Component = Component
    { id :: String
    , endpoint :: String
    , must_succeed :: Bool
    } deriving (Generic)

instance FromJSON Component


decodeConfiguration :: BL.ByteString -> Either String Configuration
decodeConfiguration = eitherDecode
