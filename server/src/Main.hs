{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Lens
import Data.OpenApi hiding (Server, server)
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import RIO hiding ((.~))
import Servant
import Servant.OpenApi

main :: IO ()
main = run 8000 $ simpleCors app

app :: Application
app = serve api server

type API = GetInt

type GetInt = "getint" :> Capture "int" Int :> Get '[JSON] Int

type SwaggerAPI = "swagger.json" :> Get '[JSON] OpenApi

type FullAPI = SwaggerAPI :<|> API

api :: Proxy FullAPI
api = Proxy

server :: Server FullAPI
server = pure apiSwagger :<|> \_ -> pure 7

apiSwagger :: OpenApi
apiSwagger =
  toOpenApi (Proxy :: Proxy API)
    & info . title .~ "Todo API"
    & info . version .~ "1.0"
    & info . description ?~ "This is an API that tests swagger integration"
    & info . license ?~ ("MIT" & url ?~ URL "http://mit.com")
    & subOperations (Proxy :: Proxy GetInt) (Proxy :: Proxy API) . operationId ?~ ("test" :: Text)
