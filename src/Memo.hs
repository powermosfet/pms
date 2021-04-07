{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Memo
    ( Memo(..)
    ) where

import Data.Aeson (FromJSON)
import GHC.Generics (Generic)
import Protolude (Char, Show, Text)

data Memo =
    Memo
        { subject :: Text
        , content :: Text
        }
    deriving (Generic, Show, FromJSON)
