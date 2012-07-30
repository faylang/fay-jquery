module Test (main) where

import SameDir
import Language.Fay.Prelude
import Language.Fay.JQuery

main :: Fay ()
main = do
    sameDirAlert
    moduleAlert
