{-# LANGUAGE RecordWildCards #-}

module Model.Backoff where

import Control.Concurrent

data Backoff = Backoff
  { current
  , cap
  , totalWait :: {-# UNPACK #-} !Int
  }

default :: Backoff
default = Backoff 0 10000 0 -- 10ms

backoff :: Backoff -> IO Backoff
backoff b@Backoff{..}
  | current < 1 = do
    yield
    return b { current = current + 1 } 
  | otherwise = do
    threadDelay current
    return b { current = min cap (2*current), totalWait = totalWait + current } 
