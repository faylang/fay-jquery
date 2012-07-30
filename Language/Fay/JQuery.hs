module Language.Fay.JQuery  where

{--
Note that this is very much in flux. Function names, type signatures, and
data types all subject to drastic change.
--}

import Language.Fay.Prelude
import Language.Fay.FFI

data JQuery
instance Foreign JQuery where

-- Things that I wish were in the Fay library
data Element
instance Foreign Element where

getThis :: Fay JQuery
getThis = ffi "this" FayNone

-- jQuery()
selectElement :: Element -> Fay JQuery
selectElement = ffi "jQuery(%1)" FayNone

selectObject :: (Foreign a) => a -> Fay JQuery
selectObject = ffi "jQuery(%1)" FayNone

select       :: String -> Fay JQuery
select       = ffi "jQuery(%1)" FayNone

selectEmpty :: Fay JQuery
selectEmpty = ffi "jQuery()" FayNone

createJQuery :: (Foreign a) => String -> a -> Fay JQuery
createJQuery = ffi "jQuery(%1, %2)" FayNone

ready :: Fay () -> Fay ()
ready = ffi "jQuery(%1)" FayNone

-- TODO: html with props

addClass :: String -> JQuery -> Fay JQuery
addClass = ffi "%2.addClass(%1)" FayNone

-- FIXME: can't get this to work
addClassWith :: (Double -> String -> Fay String) -> JQuery -> Fay JQuery
addClassWith = ffi "%2.addClass(_(%1))" FayNone

getAttr :: String -> JQuery -> Fay JQuery
getAttr = ffi "%2.attr(%1)" FayNone

setAttr :: String -> String -> JQuery -> Fay JQuery
setAttr = ffi "%3.attr(%1, %2)" FayNone

-- TODO: setAttrs with map

-- FIXME
--setAttr :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery

setText :: String -> JQuery -> Fay JQuery
setText = ffi "%2.text(%1)" FayNone

getText :: JQuery -> Fay String
getText = ffi "%1.text()" FayString

setStyle :: String -> String -> JQuery -> Fay JQuery
setStyle = ffi "%3.css(%1, %2)" FayNone



--moduleAlert :: Fay ()
--moduleAlert = ffi "window.alert('But in a qualified module it doesn\\'t.')" FayNone
