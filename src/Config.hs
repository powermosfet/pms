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
        , ntfyHost :: Text
        , ntfyTopic :: Text
        }
    deriving (Show)

fromEnvironment :: [([Char], [Char])] -> Either [Char] Config
fromEnvironment env =
    let find key = maybeToEither ("Could not find env. var. " <> key) (lookup key env)
        findOptional key = lookup key env
        normalizeNtfyHost host =
            if "http://" `T.isPrefixOf` host || "https://" `T.isPrefixOf` host
                then host
                else "https://" <> host
     in Config <$> (find "APP_PORT" >>= readEither) <*>
        pure (normalizeNtfyHost (T.pack (fromMaybe "https://ntfy.sh" (findOptional "NTFY_HOST")))) <*>
        (T.pack <$> find "NTFY_TOPIC")
