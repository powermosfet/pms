{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Memo
    ( Memo(..)
    ) where

import Data.Aeson (FromJSON)
import qualified Data.Text.Lazy as L
import GHC.Generics (Generic)
import Protolude (Char, Show)

data Memo =
    Memo
        { subject :: [Char]
        , content :: L.Text
        }
    deriving (Generic, Show, FromJSON)
