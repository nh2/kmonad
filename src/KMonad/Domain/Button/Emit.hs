{-|
Module      : KMonad.Domain.Button.Emit
Description : A button that emits a 'KeyEvent' on 'BPress' and 'BRelease'
Copyright   : (c) David Janssen, 2019
License     : MIT

Maintainer  : janssen.dhj@gmail.com
Stability   : experimental
Portability : non-portable (MPTC with FD, FFI to Linux-only c-code)

The 'mkEmit' 'Button' is the standard "this is a button that types a letter"
style button. When pressed, it emits a 'Press' 'KeyEvent' for its 'KeyCode', and
when released, a 'Release' type event.

-}
module KMonad.Domain.Button.Emit
  ( mkEmit
  , mkEmitM
  )
where

import KMonad.Core.Button
import KMonad.Core.Keyboard
import KMonad.Core.KeyCode
import KMonad.Domain.Effect


-- | Return an Emit button
mkEmit :: (MonadEmit m, MonadNow m)
  => KeyCode  -- ^ The keycode to emit on manipulation
  -> Button m -- ^ The resulting button
mkEmit kc = mkButton $ \case
  BPress   -> press kc   <$> now >>= emitKey
  BRelease -> release kc <$> now >>= emitKey

-- | Return an Emit button from within some Monad
mkEmitM :: (MonadEmit m, MonadNow m, Monad n)
  => KeyCode      -- ^ The keycode to emit on manipulation
  -> n (Button m) -- ^ The resulting button
mkEmitM = return . mkEmit
