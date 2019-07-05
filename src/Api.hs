{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api
    ( PmsApi
    , server
    , api
    ) where

import Config (Config(..))
import Data.Aeson (ToJSON, (.=), object, toJSON)
import Mail (mailer)
import Memo (Memo(..))
import Protolude (Eq, Show, Text, ($), liftIO, return)
import Servant ((:>), JSON, Post, Proxy(..), ReqBody)
import Servant.Server (Handler)

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
    liftIO $ mailer config memo
    return Success

api :: Proxy PmsApi
api = Proxy
