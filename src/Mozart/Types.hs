{-# LANGUAGE DeriveGeneric #-}

module Mozart.Types where

import GHC.Generics (Generic)

data Envelope = Envelope
    { head :: [String]
    , bodyInline :: String
    , bodyLast :: [String]
    }

type Configuration = [Component]

data Component = Component
    { name :: String
    , version :: String
    , source :: String
    , parameters :: [Parameter]
    } deriving (Generic)

type Parameter = (String, String)
