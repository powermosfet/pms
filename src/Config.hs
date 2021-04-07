module Config
    ( Config(..)
    , fromEnvironment
    ) where

import Protolude 

import Data.List (lookup)
import Network.HaskellNet.Auth (Password, UserName)
import Network.Socket (HostName, PortNumber)
import qualified Data.Text as T

data Config =
    Config
        { port :: Int
        , signalUrl :: Text
        , signalSender :: Text
        , signalRecipient :: Text
        }
    deriving (Show)

fromEnvironment :: [([Char], [Char])] -> Either [Char] Config
fromEnvironment env =
    let find key = maybeToEither ("Could not find env. var. " <> key) (lookup key env)
     in Config <$> (find "APP_PORT" >>= readEither) <*>
        (T.pack <$> find "SIGNAL_URL") <*>
        (T.pack <$> find "SIGNAL_SENDER") <*>
        (T.pack <$> find "SIGNAL_RECIPIENT")
