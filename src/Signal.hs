{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Protolude 

import Config (Config(..))
import Data.Aeson (ToJSON, encode)
import GHC.Generics (Generic)
import Memo (Memo(..))
import Network.HTTP.Simple
import qualified Data.ByteString.Lazy as BS
import qualified Data.Text as T
import qualified System.Command as Cmd

data SignalMessage =
    SignalMessage
        { base64_attachments :: [Text]
        , message :: Text
        , number :: Text
        , recipients :: [Text]
        }
    deriving (Generic, Show, ToJSON)

signalMessage :: Config -> Memo -> SignalMessage
signalMessage (Config {..}) (Memo {..}) =
    SignalMessage { base64_attachments = []
                  , message = content
                  , number = signalSender
                  , recipients = [signalRecipient]
                  }
    

sendSignalMsg :: Config -> Memo -> IO ()
sendSignalMsg config memo = do
    let cli = T.unpack $ Config.signalCli config
    let sender = show $ T.unpack $ Config.signalSender config
    let content = show $ T.unpack $ Memo.content memo
    let recipient = show $ T.unpack $ Config.signalRecipient config
    let configPath = T.unpack $ Config.signalConfigPath config
    Cmd.command_ [] cli [ "--config", , "-a", sender, "send", "-m", content, recipient ]
