{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Lazy as BL
import Mozart.Composition

main :: IO ()
main = do
    configuration <- BL.getContents
    template <- BL.readFile "test/template.html"
    page <- compose configuration template
    putStrLn page
