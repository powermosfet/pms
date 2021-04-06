{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Protolude 

import Config (Config(..))
import Data.Aeson (ToJSON, encode)
import GHC.Generics (Generic)
import Memo (Memo(..))
import Network.HTTP (Response, Request(..), postRequestWithBody, simpleHTTP)
import Network.Stream
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.Text.Lazy as L

data SignalMessage =
    SignalMessage
        { base64_attachments :: [[Char]]
        , message :: L.Text
        , number :: [Char]
        , recipients :: [[Char]]
        }
    deriving (Generic, Show, ToJSON)

signalMessage :: Config -> Memo -> SignalMessage
signalMessage (Config {..}) (Memo {..}) =
    SignalMessage { base64_attachments = []
                  , message = content
                  , number = signalSender
                  , recipients = [signalRecipient]
                  }
    

sendSignalMsg :: Config -> Memo -> IO (Either ConnError (Response [Char]))
sendSignalMsg config memo = do
    let r = postRequestWithBody (signalUrl config ++ "/v2/send") "application/json" (BS.unpack (encode (signalMessage config memo)))
    print r
    simpleHTTP r

