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

setWidthWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
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

-- TODO: unify these under a typeclass?
addSelector :: String -> JQuery -> Fay JQuery
addSelector = ffi "$2.add(%1)" FayNone

addElement :: Element -> JQuery -> Fay JQuery
addElement = ffi "%2.add(%1)" FayNone

addHtml :: String -> JQuery -> Fay JQuery
addHtml = ffi "%2.add(%1)" FayNone

add :: JQuery -> JQuery -> Fay JQuery
add = ffi "%2.add(%1)" FayNone

addSelectorWithContext :: String -> JQuery -> JQuery -> Fay JQuery
addSelectorWithContext = ffi "%3.add(%1, %2)" FayNone

andSelf :: JQuery -> Fay JQuery
andSelf = ffi "%1.andSelf()" FayNone

children :: JQuery -> Fay JQuery
children = ffi "%1.children()" FayNone

childrenMatching :: String -> JQuery -> Fay JQuery
childrenMatching = ffi "%2.children(%1)" FayNone

closestSelector :: String -> JQuery -> Fay JQuery
closestSelector = ffi "%2.closest(%1)" FayNone

-- TODO: is context really a string?
closestWithContext :: String -> String -> JQuery -> Fay JQuery
closestWithContext = ffi "%3.closest(%1, %2)" FayNone

closest :: JQuery -> JQuery -> Fay JQuery
closest = ffi "%2.closest(%1)" FayNone

closestElement :: Element -> JQuery -> Fay JQuery
closestElement = ffi "%2.closest(%1)" FayNone

-- TODO: include deprecated array-based signature?

contents :: JQuery -> Fay JQuery
contents = ffi "%1.contents()" FayNone

-- This just isn't cool. Can't we all just use map?
each :: (Double -> Element -> Bool) -> JQuery -> Fay JQuery
each = ffi "%2.each(%1)" FayNone

end :: JQuery -> Fay JQuery
end = ffi "%1.end()" FayNone

eq :: Double -> JQuery -> Fay JQuery
eq = ffi "%2.eq(%1)" FayNone

filter :: String -> JQuery -> Fay JQuery
filter = ffi "%2.filter(%1)" FayNone

filterWith :: (Double -> Fay Bool) -> JQuery -> Fay JQuery
filterWith = ffi "%2.filter(%1)" FayNone

filterElement :: Element -> JQuery -> Fay JQuery
filterElement = ffi "%2.filter(%1)" FayNone

filterJQuery :: JQuery -> JQuery -> Fay JQuery
filterJQuery = ffi "%2.filter(%1)" FayNone

find :: String -> JQuery -> Fay JQuery
find = ffi "%2.find(%1)" FayNone

findJQuery :: JQuery -> JQuery -> Fay JQuery
findJQuery = ffi "%2.find(%1)" FayNone

findElement :: Element -> JQuery -> Fay JQuery
findElement = ffi "%2.find(%1)" FayNone

first :: JQuery -> Fay JQuery
first = ffi "%1.first()" FayNone

has :: String -> JQuery -> Fay JQuery
has = ffi "%2.find(%1)" FayNone

hasElement :: Element -> JQuery -> Fay JQuery
hasElement = ffi "%2.find(%1)" FayNone

is :: String -> JQuery -> Fay JQuery
is = ffi "%2.is(%1)" FayNone

isWith :: (Double -> Bool) -> JQuery -> Fay JQuery
isWith = ffi "%2.is(%1)" FayNone

isJQuery :: JQuery -> JQuery -> Fay JQuery
isJQuery = ffi "%2.is(%1)" FayNone

isElement :: Element -> JQuery -> Fay JQuery
isElement = ffi "%2.is(%1)" FayNone

last :: JQuery -> Fay JQuery
last = ffi "%1.last()" FayNone

-- FIXME: is the return value of the callback right?
jQueryMap :: (Double -> Element -> Fay JQuery) -> JQuery -> Fay JQuery
jQueryMap = ffi "%2.map(%1)" FayNone

next :: JQuery -> Fay JQuery
next = ffi "%1.next()" FayNone

nextSelector :: String -> JQuery -> Fay JQuery
nextSelector = ffi "%2.next(%1)" FayNone

nextAll :: JQuery -> Fay JQuery
nextAll = ffi "%1.nextAll()" FayNone

nextAllSelector :: String -> JQuery -> Fay JQuery
nextAllSelector = ffi "%2.nextAll(%1)" FayNone

nextUntil :: String -> JQuery -> Fay JQuery
nextUntil = ffi "%2.nextUntil(%1)" FayNone

nextUntilFiltered :: String -> String -> JQuery -> Fay JQuery
nextUntilFiltered = ffi "%3.nextUntil(%1, %2)" FayNone

nextUntilElement :: Element -> JQuery -> Fay JQuery
nextUntilElement = ffi "%2.nextUntil(%1)" FayNone

nextUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
nextUntilElementFiltered = ffi "%3.nextUntil(%1, %2)" FayNone

not :: String -> JQuery -> Fay JQuery
not = ffi "%2.not(%1)" FayNone

notElement :: Element -> JQuery -> Fay JQuery
notElement = ffi "%2.not(%1)" FayNone

notElements :: [Element] -> JQuery -> Fay JQuery
notElements = ffi "%2.not(%1)" FayNone

notWith :: (Double -> Bool) -> JQuery -> Fay JQuery
notWith = ffi "%2.not(%1)" FayNone

notJQuery :: JQuery -> JQuery -> Fay JQuery
notJQuery = ffi "%2.not(%1)" FayNone

offsetParent :: JQuery -> Fay JQuery
offsetParent = ffi "%1.offsetParent()" FayNone

parent :: JQuery -> Fay JQuery
parent = ffi "%1.parent()" FayNone

parentSelector :: String -> JQuery -> Fay JQuery
parentSelector = ffi "%2.parent(%1)" FayNone

parents :: JQuery -> Fay JQuery
parents = ffi "%1.parents()" FayNone

parentsSelector :: String -> JQuery -> Fay JQuery
parentsSelector = ffi "%2.parents(%1)" FayNone

parentsUntil :: String -> JQuery -> Fay JQuery
parentsUntil = ffi "%2.parentsUntil(%1)" FayNone

parentsUntilFiltered :: String -> String -> JQuery -> Fay JQuery
parentsUntilFiltered = ffi "%3.parentsUntil(%1, %2)" FayNone

parentsUntilElement :: Element -> JQuery -> Fay JQuery
parentsUntilElement = ffi "%2.parentsUntil(%1)" FayNone

parentsUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
parentsUntilElementFiltered = ffi "%3.parentsUntil(%1, %2)" FayNone

prev :: JQuery -> Fay JQuery
prev = ffi "%1.prev()" FayNone

prevSelector :: String -> JQuery -> Fay JQuery
prevSelector = ffi "%2.prev(%1)" FayNone

prevAll :: JQuery -> Fay JQuery
prevAll = ffi "%1.prevAll()" FayNone

prevAllSelector :: String -> JQuery -> Fay JQuery
prevAllSelector = ffi "%2.prevAll(%1)" FayNone

prevUntil :: String -> JQuery -> Fay JQuery
prevUntil = ffi "%2.prevUntil(%1)" FayNone

prevUntilFiltered :: String -> String -> JQuery -> Fay JQuery
prevUntilFiltered = ffi "%3.prevUntil(%1, %2)" FayNone

prevUntilElement :: Element -> JQuery -> Fay JQuery
prevUntilElement = ffi "%2.prevUntil(%1)" FayNone

prevUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
prevUntilElementFiltered = ffi "%3.prevUntil(%1, %2)" FayNone

siblings :: JQuery -> Fay JQuery
siblings = ffi "%1.siblings()" FayNone

siblingsSelector :: String -> JQuery -> Fay JQuery
siblingsSelector = ffi "%2.siblings(%1)" FayNone

slice :: Double -> JQuery -> Fay JQuery
slice = ffi "%2.slice(%1)" FayNone

sliceFromTo :: Double -> Double -> JQuery -> Fay JQuery
sliceFromTo = ffi "%3.slice(%1, %2)" FayNone







-- vim implementation shortcut
-- inoremap <F6> <ESC>:normal 0ywo<ESC>pa= ffi "" FayNone<ESC>F"i



----
---- Utilities
----
