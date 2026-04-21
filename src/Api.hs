{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api
    ( PmsApi
    , server
    , api
    ) where

import Config (Config(..))
import Data.Aeson (ToJSON, (.=), object, toJSON)
import Memo (Memo(..))
import Ntfy (sendNtfyMsg)
import Protolude hiding (Handler)
import Servant ((:>), JSON, Post, Proxy(..), ReqBody)
import Servant.Server (Handler)
import qualified Control.Exception as E

data MemoResult
    = Success
    | Failure
    deriving (Show, Eq)

instance ToJSON MemoResult where
    toJSON Success = object ["result" .= ("success" :: Text)]
    toJSON Failure = object ["result" .= ("failure" :: Text)]

type PmsApi = "memo" :> ReqBody '[ JSON] Memo :> Post '[ JSON] MemoResult

server :: Config -> Memo -> Handler MemoResult
server = postMemo

postMemo :: Config -> Memo -> Handler MemoResult
postMemo config memo = do
    res <- liftIO (E.try (sendNtfyMsg config memo) :: IO (Either E.SomeException ()))
    case res of
        Left _ -> return Failure
        Right _ -> return Success

api :: Proxy PmsApi
api = Proxy
