{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Signal where

import Protolude 

import Config (Config(..))
import Data.Aeson (ToJSON, encode)
import GHC.Generics (Generic)
import Memo (Memo(..))
import Network.HTTP.Simple
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as BS

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
    BS.putStrLn (encode (signalMessage config memo))
    let req = setRequestBodyJSON (signalMessage config memo) $ setRequestMethod "POST" $ parseRequest_ $ T.unpack (signalUrl config) ++ "/v2/send" 

    response <- httpLBS req
    print response
