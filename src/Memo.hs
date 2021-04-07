{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Memo
    ( Memo(..)
    ) where

import Data.Aeson (FromJSON)
import GHC.Generics (Generic)
import Protolude (Char, Show)

data Memo =
    Memo
        { subject :: [Char]
        , content :: [Char]
        }
    deriving (Generic, Show, FromJSON)
