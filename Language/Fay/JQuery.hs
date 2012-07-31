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

----
---- Ajax
----

-- TODO

----
---- Attributes
----

addClass :: String -> JQuery -> Fay JQuery
addClass = ffi "%2.addClass(%1)" FayNone

-- FIXME: https://github.com/chrisdone/fay/issues/38
addClassWith :: (Double -> String -> Fay String) -> JQuery -> Fay JQuery
addClassWith = ffi "%2.addClass(function(x,i){ return Fay$$serialize(StringType,%1(x,Fay$$list(i)).value); })" FayNone

getAttr :: String -> JQuery -> Fay String
getAttr = ffi "%2.attr(%1)" FayNone

setAttr :: String -> String -> JQuery -> Fay JQuery
setAttr = ffi "%3.attr(%1, %2)" FayNone

-- TODO: setAttrs with map

setAttrWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setAttrWith = ffi "%3.attr(%1, %2)" FayNone

hasClass :: String -> JQuery -> Fay Bool
hasClass = ffi "%2.hasClass(%1)" FayNone

getHtml :: JQuery -> Fay String
getHtml = ffi "%1.html()" FayNone

setHtml :: String -> JQuery -> Fay JQuery
setHtml = ffi "%2.html(%1)" FayNone

setHtmlWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
setHtmlWith = ffi "%2.html(%1)" FayNone

-- TODO: html with props

getProp :: String -> JQuery -> Fay String
getProp = ffi "%2.prop(%1)" FayNone

setProp :: String -> String -> JQuery -> Fay JQuery
setProp = ffi "%3.prop(%1, %2)" FayNone

-- TODO: setProp with map

setPropWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setPropWith = ffi "%3.prop(%1, %2)" FayNone

removeAttr :: String -> JQuery -> Fay JQuery
removeAttr = ffi "%2.removeAttr(%1)" FayNone

removeClass :: String -> JQuery -> Fay JQuery
removeClass = ffi "%2.removeClass(%1)" FayNone

removeClassWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery 
removeClassWith = ffi "%2.removeClass(%1)" FayNone

removeProp :: String -> JQuery -> Fay JQuery
removeProp = ffi "%2.removeProp(%1)" FayNone

toggleClass :: String -> JQuery -> Fay JQuery
toggleClass = ffi "%2.toggleClass(%1)" FayNone

toggleClassBool :: String -> Bool -> JQuery -> Fay JQuery
toggleClassBool = ffi "%3.toggleClass(%1, %2)" FayNone

toggleAllClasses :: Bool -> JQuery -> Fay JQuery
toggleAllClasses = ffi "%2.toggleClass(%1)" FayNone

toggleClassWith :: (Double -> String -> Bool -> Fay JQuery) -> JQuery -> Fay JQuery
toggleClassWith = ffi "%2.toggleClass(%1)" FayNone

toggleClassBoolWith :: (Double -> String -> Bool -> Fay JQuery) -> Bool -> JQuery -> Fay JQuery
toggleClassBoolWith = ffi "%3.toggleClass(%1, %2)" FayNone

getVal :: (Foreign a) => JQuery -> Fay a
getVal = ffi "%1.val()" FayNone

setVal :: String -> JQuery -> Fay JQuery
setVal = ffi "%2.val(%1)" FayNone

setValWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
setValWith = ffi "%2.val(%1)" FayNone

setText :: String -> JQuery -> Fay JQuery
setText = ffi "%2.text(%1)" FayNone

getText :: JQuery -> Fay String
getText = ffi "%1.text()" FayString

----
---- Core
----

holdReady :: Bool -> Fay JQuery
holdReady = ffi "jQuery.holdReady(%1)" FayNone

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
-- end jQuery()

-- is noConflict useful in the context of Fay?
noConflict :: Fay JQuery
noConflict = ffi "jQuery.noConflict()" FayNone

noConflictBool :: Bool -> Fay JQuery
noConflictBool = ffi "jQuery.noConflict(%1)" FayNone

-- TODO: jQuery.sub()

-- TODO: jQuery.when(): figure out Deferred first

----
---- CSS
----

getCss :: String -> JQuery -> Fay String
getCss = ffi "%2.css(%1)" FayNone

setCss :: String -> String -> JQuery -> Fay JQuery
setCss = ffi "%3.css(%1, %2)" FayNone

setCssWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setCssWith = ffi "%3.css(%1, %2)" FayNone

getHeight :: JQuery -> Fay Double
getHeight = ffi "%1.height()" FayNone

setHeight :: Double -> JQuery -> Fay JQuery
setHeight = ffi "%2.height(%1)" FayNone

setHeightWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
setHeightWith = ffi "%2.height(%1)" FayNone

getInnerHeight :: JQuery -> Fay Double
getInnerHeight = ffi "%1.innerHeight()" FayNone

getInnerWidth :: JQuery -> Fay Double
getInnerWidth = ffi "%1.innerWidth()" FayNone

-- TODO: figure out how to marshal coordinates
--getOffset :: JQuery -> Fay 
--getOffset = ffi "%1.offset()" FayNone

--setOffset 
--setOffsetWith

-- TODO: css with map

-- TODO: cssHooks

getOuterHeight :: JQuery -> Fay Double
getOuterHeight = ffi "%1.outerHeight()" FayNone

-- FIXME: better name
getOuterHeightBool :: Bool -> JQuery -> Fay Double
getOuterHeightBool = ffi "%2.outerHeight(%1)" FayNone

getOuterWidth :: JQuery -> Fay Double
getOuterWidth = ffi "%1.outerWidth()" FayNone

getOuterWidthBool :: Bool -> JQuery -> Fay Double
getOuterWidthBool = ffi "%2.outerWidth(%1)" FayNone

-- TODO: marshal coordinates as in offset()
-- getPosition

getScrollLeft :: JQuery -> Fay Double
getScrollLeft = ffi "%1.scrollLeft()" FayNone

setScrollLeft :: Double -> JQuery -> Fay JQuery
setScrollLeft = ffi "%2.scrollLeft(%1)" FayNone

getScrollTop :: JQuery -> Fay Double
getScrollTop = ffi "%1.scrollTop()" FayNone

setScrollTop :: Double -> JQuery -> Fay JQuery
setScrollTop = ffi "%2.scrollTop(%1)" FayNone

getWidth :: JQuery -> Fay Double
getWidth = ffi "%1.width()" FayNone

setWidth :: Double -> JQuery -> Fay JQuery
setWidth = ffi "%2.width(%1)" FayNone

setWidthWith :: (Double -> Double -> JQuery Double) -> JQuery -> Fay JQuery
setWidthWith = ffi "%2.width(%1)" FayNone


----
---- Data
----

----
---- Deferred Object
----

----
---- Dimensions
----

----
---- Effects
----

----
---- Events
----

----
---- Forms
----

----
---- Internals
----

----
---- Manipulation
----

----
---- Miscellaneous
----

----
---- Offset
----

----
---- Plugins
----

----
---- Properties
----

----
---- Selectors
----

----
---- Traversing
----

----
---- Utilities
----
