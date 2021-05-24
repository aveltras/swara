{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Database.Schema where

import RIO
import Squeal.PostgreSQL

type Schema = Public Schema_v0

type Schema_v0 =
  '[ "ragas" ::: 'Table (RagasK :=> RagasC)
   ]

migrations :: Path (Migration (IsoQ Definition)) (Public '[]) Schema
migrations = v0 :>> Done

v0 :: Migration (IsoQ Definition) (Public '[]) Schema
v0 =
  Migration
    "init"
    IsoQ
      { up = setup,
        down = teardown
      }

setup :: Definition (Public '[]) Schema
setup =
  createTable
    #ragas
    ( serial `as` #uid
        :* (text & notNullable) `as` #name
    )
    (primaryKey #uid `as` #pk_ragas)

teardown :: Definition Schema (Public '[])
teardown = dropTable #ragas

type RagasC =
  '[ "uid" ::: 'Def :=> 'NotNull 'PGint4,
     "name" ::: 'NoDef :=> 'NotNull 'PGtext
   ]

type RagasK =
  '[ "pk_ragas" ::: 'PrimaryKey '["uid"]
   ]
