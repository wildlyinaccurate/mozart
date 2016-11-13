{-# LANGUAGE DeriveGeneric #-}

module Mozart.Types where

import GHC.Generics (Generic)

data Envelope = Envelope
    { head :: [String]
    , bodyInline :: String
    , bodyLast :: [String]
    } deriving (Generic)

data Configuration = Configuration
    { contents :: [Component]
    } deriving (Generic)

data Component = Component
    { id :: String
    , endpoint :: String
    , must_succeed :: Bool
    } deriving (Generic)
