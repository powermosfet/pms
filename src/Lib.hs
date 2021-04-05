module Lib
    ( pms
    ) where

import Protolude
import qualified Protolude.Base

import Api (api, server)
import qualified Config
import Network.Wai.Handler.Warp (run)
import Servant (serve)
import System.Environment (getEnvironment)

pms :: IO ()
pms = do
    env <- getEnvironment
    case Config.fromEnvironment env of
        Right config -> do
            putStrLn (Protolude.Base.show config)
            run (Config.port config) (serve api (server config))
        Left err -> putStrLn err
