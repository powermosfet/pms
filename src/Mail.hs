module Mail
    ( mailer
    ) where

import Config (Config(..))
import Memo (Memo(..))
import Network.HaskellNet.SMTP.SSL (AuthType(LOGIN), authenticate, doSMTPSSL, sendMimeMail)
import Protolude (Bool(..), ($))
import System.IO (IO, putStrLn)

mailer :: Config -> Memo -> IO ()
mailer (Config {..}) (Memo {..}) =
    doSMTPSSL smtpHost $ \conn -> do
        authSuccess <- authenticate LOGIN smtpUser smtpPassword conn
        case authSuccess of
            True -> sendMimeMail mailRecipient mailSender subject content content [] conn
            False -> putStrLn "Authentication failure"
