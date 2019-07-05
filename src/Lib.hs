module Lib
    ( pms
    ) where

import Api (api, server)
import qualified Config
import Network.Wai.Handler.Warp (run)
import Protolude (Either(..), IO, print)
import Servant (serve)
import System.Environment (getEnvironment)

pms :: IO ()
pms = do
    env <- getEnvironment
    case Config.fromEnvironment env of
        Right config -> do
            print config
            run (Config.port config) (serve api (server config))
        Left err -> print err
