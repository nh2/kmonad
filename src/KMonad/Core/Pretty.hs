{-|
Module      : KMonad.Core.Pretty
Description : Pretty-printing KMonad data
Copyright   : (c) David Janssen, 2019
License     : MIT
Maintainer  : janssen.dhj@gmail.com
Stability   : experimental
Portability : portable
-}
module KMonad.Core.Pretty
  ( -- * The Pretty Typeclass
    -- $pretty
    Pretty(..)

    -- * Utilities
    -- $util
  , pprint
  , tshow
  )
where

import Control.Lens
import Control.Monad.Trans

import KMonad.Core.Keyboard
import KMonad.Core.Time

import qualified Data.Text    as T
import qualified Data.Text.IO as T

--------------------------------------------------------------------------------
-- $pretty
--
-- Any item that can be pretty-printed can be made a member of 'Pretty'. This
-- typeclass essentially just exists as a stand-in for 'Show' for those cases
-- where we do not care about having backwards 'Read' capability.

-- | The 'Pretty' type class describing how to print something prettily
class Pretty a where
  pretty :: a -> T.Text

instance Pretty Time where
  pretty t = let s'  = fromIntegral $ t^.s  :: Int
                 ns' = fromIntegral $ t^.ns :: Int
             in tshow s' <> ":" <> tshow ns'

instance Pretty KeyEventType where
  pretty Press   = "P"
  pretty Release = "R"
  pretty Repeat  = "E"


instance Pretty KeyEvent where
  pretty e = pretty (e^.time)
          <> "   "
          <> pretty (e^.eventType)
          <> "   "
          <> tshow (e^.keyCode)

--------------------------------------------------------------------------------
-- $util

-- | Pretty-print something to stdout using pretty
pprint :: (MonadIO m, Pretty a) => a -> m ()
pprint = liftIO . T.putStrLn . pretty

-- | 'show' a value, but output 'T.Text'
tshow :: Show a => a -> T.Text
tshow = T.pack . show

