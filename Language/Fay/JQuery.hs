module Language.Fay.JQuery (moduleAlert) where

import Language.Fay.Prelude
import Language.Fay.FFI

moduleAlert :: Fay ()
moduleAlert = ffi "window.alert('But in a qualified module it doesn\'t.')" FayNone
