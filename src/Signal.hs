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
    let sender = show $ T.unpack $ Config.signalSender config
    let content = show $ T.unpack $ Memo.content memo
    let recipient = show $ T.unpack $ Config.signalRecipient config
    Cmd.command_ [] "signal-cli" [ "-a", sender, "send", "-m", content, recipient ]
