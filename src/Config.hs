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
        , smtpHost :: HostName
        , smtpUser :: UserName
        , smtpPassword :: Password
        , smtpPort :: PortNumber
        , mailSender :: [Char]
        , mailRecipient :: [Char]
        }
    deriving (Show)

fromEnvironment :: [([Char], [Char])] -> Either [Char] Config
fromEnvironment env =
    let find key = maybeToEither ("Could not find env. var. " <> key) (lookup key env)
     in Config <$> (find "APP_PORT" >>= readEither) <*> find "SMTP_HOST" <*> (find "SMTP_USER") <*> (find "SMTP_PW") <*>
        (find "SMTP_PORT" >>= (readEither)) <*>
        (find "MAIL_SENDER") <*>
        (find "MAIL_RECIPIENT")
