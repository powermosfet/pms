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
import qualified Data.ByteString.Lazy.Char8 as BSC
import qualified Data.Text as T

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
    BSC.putStrLn (encode (signalMessage config memo))
    let req = T.unpack (signalUrl config) ++ "/v2/send" &
              parseRequest_ &
              setRequestMethod "POST" &
              setRequestBodyJSON (signalMessage config memo)

    httpLBS req >>= print
