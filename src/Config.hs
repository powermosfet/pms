module Config
    ( Config(..)
    , fromEnvironment
    ) where

import Data.List (lookup)
import Network.HaskellNet.Auth (Password, UserName)
import Network.Socket (HostName, PortNumber)
import Protolude (Char, Either(..), Int, Show, (<$>), (<*>), (<>), (>>=), maybeToEither, readEither)

data Config =
    Config
        { port :: Int
        , signalUrl :: [Char]
        , signalSender :: [Char]
        , signalRecipient :: [Char]
        }
    deriving (Show)

fromEnvironment :: [([Char], [Char])] -> Either [Char] Config
fromEnvironment env =
    let find key = maybeToEither ("Could not find env. var. " <> key) (lookup key env)
     in Config <$> (find "APP_PORT" >>= readEither) <*>
        (find "SIGNAL_URL") <*>
        (find "SIGNAL_SENDER") <*>
        (find "SIGNAL_RECIPIENT")
