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
import qualified Data.ByteString.Lazy.UTF8 as BS
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
    

sendSignalMsg :: Config -> Memo -> IO (Either ConnError (Response [Char]))
sendSignalMsg config memo = do
    let json = BS.toString (encode (signalMessage config memo))
    let r = postRequestWithBody (T.unpack (signalUrl config) ++ "/v2/send") "application/json" json
    putStrLn json
    simpleHTTP r

