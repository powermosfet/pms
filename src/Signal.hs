{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Protolude 

import Config (Config(..))
import Data.Aeson (ToJSON, encode)
import GHC.Generics (Generic)
import Memo (Memo(..))
import Network.HTTP (Response, Request(..), postRequest, simpleHTTP)
import Network.Stream
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Internal as BS

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
    

sendSignalMsg :: Config -> Memo -> IO (Either ConnError (Response BS.ByteString))
sendSignalMsg config memo = do
    let r = (postRequest (T.unpack (signalUrl config) ++ "/v2/send")) { rqBody = encode (signalMessage config memo) }
    print r
    simpleHTTP r

