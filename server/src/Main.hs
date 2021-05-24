{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Lens
import Data.Aeson.Encode.Pretty (encodePretty)
import Data.OpenApi hiding (Server, server)
import Database.Schema
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import RIO hiding ((.~))
import qualified RIO.ByteString.Lazy as BL
import Servant
import Servant.OpenApi

main :: IO ()
main = do
  BL.writeFile "../openapi.json" (encodePretty apiSwagger)
  run 8000 $ simpleCors app

app :: Application
app = serve api server

type API = GetInt

type GetInt = "getint" :> Capture "int" Int :> Get '[JSON] Int

api :: Proxy API
api = Proxy

server :: Server API
server = const $ pure 7

apiSwagger :: OpenApi
apiSwagger =
  toOpenApi (Proxy :: Proxy API)
    & info . title .~ "Todo API"
    & info . version .~ "1.0"
    & info . description ?~ "This is an API that tests swagger integration"
    & info . license ?~ ("MIT" & url ?~ URL "http://mit.com")
    & subOperations (Proxy :: Proxy GetInt) (Proxy :: Proxy API) . operationId ?~ ("test" :: Text)
