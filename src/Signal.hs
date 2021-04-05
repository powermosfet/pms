{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Network.HTTP
import Memo (Memo(..))
import Data.Aeson (ToJSON, encode)
import qualified Data.Text.Lazy as L
import GHC.Generics (Generic)
import Protolude (Char, Show, IO, (++), Either)
import Config (Config(..))
import Network.Stream
import Data.ByteString.Lazy (ByteString)

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
    

sendSignalMsg :: Config -> Memo -> IO (Either ConnError (Response ByteString))
sendSignalMsg config memo = do
    let r = getRequest (signalUrl config ++ "/v2/send")
    simpleHTTP (r { rqMethod = POST
                  , rqBody = encode (signalMessage config memo)
                  })

