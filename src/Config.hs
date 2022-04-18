module Config
    ( Config(..)
    , fromEnvironment
    ) where

import Protolude 

import Data.List (lookup)
import qualified Data.Text as T

data Config =
    Config
        { port :: Int
        , signalCli :: Text
        , signalSender :: Text
        , signalRecipient :: Text
        , signalLogRecipient :: Text
        , signalConfigPath :: Text
        }
    deriving (Show)

fromEnvironment :: [([Char], [Char])] -> Either [Char] Config
fromEnvironment env =
    let find key = maybeToEither ("Could not find env. var. " <> key) (lookup key env)
     in Config <$> (find "APP_PORT" >>= readEither) <*>
        (T.pack <$> find "SIGNAL_CLI") <*>
        (T.pack <$> find "SIGNAL_SENDER") <*>
        (T.pack <$> find "SIGNAL_RECIPIENT") <*>
        (T.pack <$> find "SIGNAL_LOG_RECIPIENT") <*>
        (T.pack <$> find "SIGNAL_CONFIG_PATH")
