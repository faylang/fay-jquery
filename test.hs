module Test (main) where

import Language.Fay.Prelude hiding (return, ($), (.), (>>=), (++))
import Language.Fay.JQuery

(>=>)       :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g     = \x -> f x >>= g

main :: Fay ()
main = ready $ do
    p <- select "#replacementParagraph"
    manipulateP p
    currentText <- getText p
    setText (currentText ++ "!!!") p
    return ()

manipulateClass index currentClass = return $ "Helloclass"

manipulateP :: JQuery -> Fay JQuery
manipulateP = setText "It's been replaced!" >=>
              --setStyle "background-color" "red" >=>
              addClass "asdf" >=>
              addClassWith manipulateClass
