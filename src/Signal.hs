{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Protolude 

import Network.HTTP (Response, Request(..), getRequest, simpleHTTP, RequestMethod(POST))
import Memo (Memo(..))
import Data.Aeson (ToJSON, encode)
import qualified Data.Text.Lazy as L
import GHC.Generics (Generic)
import Config (Config(..))
import Network.Stream
import qualified Data.ByteString.Lazy as BL

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
    

sendSignalMsg :: Config -> Memo -> IO (Either ConnError (Response BL.ByteString))
sendSignalMsg config memo = do
    let r = getRequest (signalUrl config ++ "/v2/send")
    putStrLn (encode (signalMessage config memo) :: BL.ByteString)
    simpleHTTP (r { rqMethod = POST
                  , rqBody = encode (signalMessage config memo)
                  })

