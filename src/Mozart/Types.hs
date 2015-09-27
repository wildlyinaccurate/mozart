{-# LANGUAGE DeriveGeneric #-}

module Mozart.Types where

import GHC.Generics (Generic)

data Envelope = Envelope
    { head :: [String]
    , bodyInline :: String
    , bodyLast :: [String]
    } deriving (Generic)

data Configuration = Configuration
    { meta :: Meta
    , components :: [Component]
    } deriving (Generic)

data Component = Component
    { id :: String
    , version :: String
    , endpoint :: String
    , mandatory :: Bool
    } deriving (Generic)

data Meta = Meta
    { title :: Maybe String
    , description :: Maybe String
    } deriving (Generic)
