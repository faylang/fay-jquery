module Language.Fay.JQuery (asdf) where

import Language.Fay.Prelude
import Language.Fay.FFI

asdf :: Foreign a => a -> Fay ()
asdf = ffi "window.alert('But in a qualified module it doesn\'t.')" FayNone
