module Ntfy
    ( sendNtfyMsg
    ) where

import Protolude

import Config (Config(..))
import Memo (Memo(..))
import Network.HTTP.Simple
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified System.IO.Error as IOE

sendNtfyMsg :: Config -> Memo -> IO ()
sendNtfyMsg Config {..} Memo {..} = do
    let host = T.dropWhileEnd (== '/') ntfyHost
    let url = T.unpack (host <> "/" <> ntfyTopic)

    baseReq <- parseRequest url
    let req =
            setRequestMethod "POST"
                $ setRequestHeader "Title" [TE.encodeUtf8 subject]
                $ setRequestHeader "Content-Type" ["text/plain; charset=utf-8"]
                $ setRequestBodyLBS (LBS.fromStrict (TE.encodeUtf8 content))
                $ baseReq

    resp <- httpLBS req
    let code = getResponseStatusCode resp
    unless (code >= 200 && code < 300) $
        throwIO (IOE.userError ("ntfy publish failed with HTTP " <> show code))
