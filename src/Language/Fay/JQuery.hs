{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Language.Fay.JQuery where

{--
Note that this is very much in flux. Function names, type signatures, and
data types all subject to drastic change.
--}

import           Language.Fay.FFI
import           Language.Fay.Prelude

data JQuery
instance Foreign JQuery

data JQXHR
instance Foreign JQXHR

-- Things that I wish were in the Fay library
data Element
instance Foreign Element

data Document
instance Foreign Document

data Window
instance Foreign Window

type EventType = String

type Selector = String

getThis :: Fay JQuery
getThis = ffi "this"

----
---- Ajax
----

-- This section probably incomplete, but it's a good start.
--
-- The success and error handlers have arguments that may be
-- unnecessary in your application, in that case it might be best to
-- define your own helpers that ignore these.
--
-- The success handler's type is:
-- (  f      -- data
-- -> String -- textStatus
-- -> JQXHR  -- jqXHR
--
-- The error handler's type is:
-- (  JQXHR  -- jqXHR
-- -> String -- textStatus
-- -> String -- errorThrown
--
-- Warning: the textStatus String can be null, how do we handle it?

ajax :: String -> Fay () -> Fay () -> Fay ()
ajax = ffi "jQuery.ajax(%1, { success: %2, error: %3 })"

ajaxForeign :: Foreign f
  => String -- url
  -> (f -> String -> JQXHR -> Fay ()) -- success
  -> (JQXHR -> String -> String -> Fay ()) -- error
  -> Fay ()
ajaxForeign = ffi "jQuery.ajax(%1, { success: %2, error: %3 })"

ajaxString :: Foreign f
  => String -- url
  -> (f -> String -> JQXHR -> Fay ()) -- success
  -> (JQXHR -> String -> String -> Fay ()) -- error
  -> Fay ()
ajaxString = ffi "jQuery.ajax(%1, { success: %2, error: %3 })"

-- Serializes the given object to JSON and passes it as the request body without request parameters.
-- The response is deserialized depending on its type.
ajaxPost :: (Foreign f, Foreign g)
  => String -- url
  -> f -- data
  -> (g -> String -> JQXHR -> Fay ()) -- success
  -> (JQXHR -> String -> String -> Fay ()) -- error
  -> Fay ()
ajaxPost = ffi "jQuery.ajax({\
  \ url: %1, \
  \ data: JSON.stringify(%2), \
  \ success: %3, \
  \ error: %4, \
  \ type: 'POST', \
  \ processData: false, \
  \ contentType: 'text/json', \
  \ dataType: 'json' \
  \})"

-- Same as ajaxPost but sends the data inside the given request parameter
ajaxPostParam :: (Foreign f, Foreign g)
  => String -- url
  -> String -- request parameter
  -> f -- data
  -> (g -> String -> JQXHR -> Fay ()) -- success
  -> (JQXHR -> String -> String -> Fay ()) -- error
  -> Fay ()
ajaxPostParam = ffi "jQuery.ajax({\
  \ url: '%1', \
  \ data: { '%2': JSON.stringify(%3) }, \
  \ success: %4, \
  \ error: %5, \
  \ type: 'POST', \
  \ dataType: 'json' \
  \})"

----
---- Attributes
----

addClass :: String -> JQuery -> Fay JQuery
addClass = ffi "%2.addClass(%1)"

-- FIXME: https://github.com/chrisdone/fay/issues/38
addClassWith :: (Double -> String -> Fay String) -> JQuery -> Fay JQuery
addClassWith = ffi "%2.addClass(%1)"

getAttr :: String -> JQuery -> Fay String
getAttr = ffi "%2.attr(%1)"

setAttr :: String -> String -> JQuery -> Fay JQuery
setAttr = ffi "%3.attr(%1, %2)"

-- TODO: setAttrs with map

setAttrWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setAttrWith = ffi "%3.attr(%1, %2)"

hasClass :: String -> JQuery -> Fay Bool
hasClass = ffi "%2.hasClass(%1)"

getHtml :: JQuery -> Fay String
getHtml = ffi "%1.html()"

setHtml :: String -> JQuery -> Fay JQuery
setHtml = ffi "%2.html(%1)"

setHtmlWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
setHtmlWith = ffi "%2.html(%1)"

-- TODO: html with props

getProp :: String -> JQuery -> Fay String
getProp = ffi "%2.prop(%1)"

setProp :: String -> String -> JQuery -> Fay JQuery
setProp = ffi "%3.prop(%1, %2)"

-- TODO: setProp with map

setPropWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setPropWith = ffi "%3.prop(%1, %2)"

removeAttr :: String -> JQuery -> Fay JQuery
removeAttr = ffi "%2.removeAttr(%1)"

removeClass :: String -> JQuery -> Fay JQuery
removeClass = ffi "%2.removeClass(%1)"

removeClassWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
removeClassWith = ffi "%2.removeClass(%1)"

removeProp :: String -> JQuery -> Fay JQuery
removeProp = ffi "%2.removeProp(%1)"

toggleClass :: String -> JQuery -> Fay JQuery
toggleClass = ffi "%2.toggleClass(%1)"

toggleClassBool :: String -> Bool -> JQuery -> Fay JQuery
toggleClassBool = ffi "%3.toggleClass(%1, %2)"

toggleAllClasses :: Bool -> JQuery -> Fay JQuery
toggleAllClasses = ffi "%2.toggleClass(%1)"

toggleClassWith :: (Double -> String -> Bool -> Fay JQuery) -> JQuery -> Fay JQuery
toggleClassWith = ffi "%2.toggleClass(%1)"

toggleClassBoolWith :: (Double -> String -> Bool -> Fay JQuery) -> Bool -> JQuery -> Fay JQuery
toggleClassBoolWith = ffi "%3.toggleClass(%1, %2)"

getVal :: (Foreign a) => JQuery -> Fay a
getVal = ffi "%1.val()"

setVal :: String -> JQuery -> Fay JQuery
setVal = ffi "%2.val(%1)"

setValWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
setValWith = ffi "%2.val(%1)"

setText :: String -> JQuery -> Fay JQuery
setText = ffi "%2.text(%1)"

setTextWith :: (Double -> String -> Fay JQuery) -> JQuery -> Fay JQuery
setTextWith = ffi "%2.text(%1)"

getText :: JQuery -> Fay String
getText = ffi "%1.text()"

----
---- Core
----

holdReady :: Bool -> Fay JQuery
holdReady = ffi "jQuery.holdReady(%1)"

-- jQuery()
selectElement :: Element -> Fay JQuery
selectElement = ffi "jQuery(%1)"

selectObject :: (Foreign a) => a -> Fay JQuery
selectObject = ffi "jQuery(%1)"

select :: String -> Fay JQuery
select = ffi "jQuery(%1)"

selectEmpty :: Fay JQuery
selectEmpty = ffi "jQuery()"

createJQuery :: (Foreign a) => String -> a -> Fay JQuery
createJQuery = ffi "jQuery(%1, %2)"

ready :: Fay () -> Fay ()
ready = ffi "jQuery(%1)"
-- end jQuery()

-- is noConflict useful in the context of Fay?
noConflict :: Fay JQuery
noConflict = ffi "jQuery.noConflict()"

noConflictBool :: Bool -> Fay JQuery
noConflictBool = ffi "jQuery.noConflict(%1)"

-- TODO: jQuery.sub()

-- TODO: jQuery.when(): figure out Deferred first

----
---- CSS
----

getCss :: String -> JQuery -> Fay String
getCss = ffi "%2.css(%1)"

setCss :: String -> String -> JQuery -> Fay JQuery
setCss = ffi "%3.css(%1, %2)"

setCssWith :: String -> (Double -> String -> Fay String) -> JQuery -> Fay JQuery
setCssWith = ffi "%3.css(%1, %2)"

getHeight :: JQuery -> Fay Double
getHeight = ffi "%1.height()"

setHeight :: Double -> JQuery -> Fay JQuery
setHeight = ffi "%2.height(%1)"

setHeightWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
setHeightWith = ffi "%2.height(%1)"

getInnerHeight :: JQuery -> Fay Double
getInnerHeight = ffi "%1.innerHeight()"

getInnerWidth :: JQuery -> Fay Double
getInnerWidth = ffi "%1.innerWidth()"

-- TODO: figure out how to marshal coordinates
--getOffset :: JQuery -> Fay
--getOffset = ffi "%1.offset()"

--setOffset
--setOffsetWith

-- TODO: css with map

-- TODO: cssHooks

getOuterHeight :: JQuery -> Fay Double
getOuterHeight = ffi "%1.outerHeight()"

-- FIXME: better name
getOuterHeightBool :: Bool -> JQuery -> Fay Double
getOuterHeightBool = ffi "%2.outerHeight(%1)"

getOuterWidth :: JQuery -> Fay Double
getOuterWidth = ffi "%1.outerWidth()"

getOuterWidthBool :: Bool -> JQuery -> Fay Double
getOuterWidthBool = ffi "%2.outerWidth(%1)"

-- TODO: marshal coordinates as in offset()
-- getPosition

getScrollLeft :: JQuery -> Fay Double
getScrollLeft = ffi "%1.scrollLeft()"

setScrollLeft :: Double -> JQuery -> Fay JQuery
setScrollLeft = ffi "%2.scrollLeft(%1)"

getScrollTop :: JQuery -> Fay Double
getScrollTop = ffi "%1.scrollTop()"

setScrollTop :: Double -> JQuery -> Fay JQuery
setScrollTop = ffi "%2.scrollTop(%1)"

getWidth :: JQuery -> Fay Double
getWidth = ffi "%1.width()"

setWidth :: Double -> JQuery -> Fay JQuery
setWidth = ffi "%2.width(%1)"

setWidthWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
setWidthWith = ffi "%2.width(%1)"


----
---- Data
----

----
---- Deferred Object
----

----
---- Effects
----

--
-- Basics
--

hide       :: Double -> JQuery -> Fay ()
hide = ffi "$(%1).hide(%2)"

hideSlow   :: JQuery -> Fay ()
hideSlow = ffi "$(%1).hide('slow')"

hideFast   :: JQuery -> Fay ()
hideFast = ffi "$(%1).hide('fast')"

show       :: Double -> JQuery -> Fay ()
show = ffi "$(%2).show(%1)"

showSlow   :: JQuery -> Fay ()
showSlow = ffi "$(%1).show('slow')"

showFast   :: JQuery -> Fay ()
showFast = ffi "$(%1).show('fast')"

toggle     :: Double -> JQuery -> Fay ()
toggle = ffi "$(%2).toggle(%1)"

toggleSlow :: JQuery -> Fay ()
toggleSlow = ffi "$(%1).toggle('slow')"

toggleFast :: JQuery -> Fay ()
toggleFast = ffi "$(%1).toggle('fast')"


----
---- Events
----

--
-- Browser Events
--

-- Skip error(), deprecated

resize :: (Event -> Fay ()) -> JQuery -> Fay ()
resize = ffi "%2.resize(%1)"

scroll :: (Event -> Fay ()) -> JQuery -> Fay ()
scroll = ffi "%2.scroll(%1)"

--
-- Document Loading
--

load :: (Event -> Fay()) -> JQuery -> Fay ()
load = ffi "%2.load(%1)"

documentReady :: (Event -> Fay ()) -> Document -> Fay ()
documentReady = ffi "jQuery(%2).ready(%1)"

unload :: (Event -> Fay()) -> Window -> Fay ()
unload = ffi "jQuery(%2).unload(%1)"

--
-- Mouse Events
--

click :: (Event -> Fay ()) -> JQuery -> Fay ()
click = ffi "%2.click(%1)"

dblclick :: (Event -> Fay ()) -> JQuery -> Fay ()
dblclick = ffi "%2.dblclick(%1)"

focusin :: (Event -> Fay ()) -> JQuery -> Fay ()
focusin = ffi "%2.focusin(%1)"

focusout :: (Event -> Fay ()) -> JQuery -> Fay ()
focusout = ffi "%2.focusout(%1)"

hover :: (Event -> Fay ()) -> JQuery -> Fay ()
hover = ffi "%2.hover(%1)"

mousedown :: (Event -> Fay ()) -> JQuery -> Fay ()
mousedown = ffi "%2.mousedown(%1)"

mouseenter :: (Event -> Fay ()) -> JQuery -> Fay ()
mouseenter = ffi "%2.mouseenter(%1)"

mouseleave :: (Event -> Fay ()) -> JQuery -> Fay ()
mouseleave = ffi "%2.mouseleave(%1)"

mousemove :: (Event -> Fay ()) -> JQuery -> Fay ()
mousemove = ffi "%2.mousemove(%1)"

mouseout :: (Event -> Fay ()) -> JQuery -> Fay ()
mouseout = ffi "%2.mouseout(%1)"

mouseover :: (Event -> Fay ()) -> JQuery -> Fay ()
mouseover = ffi "%2.mouseover(%1)"

mouseup :: (Event -> Fay ()) -> JQuery -> Fay ()
mouseup = ffi "%2.mouseup(%1)"

-- Argument splat since an arbitrary number of events can be attached.
-- `toggle` in jQuery but clashes with the `toggle` animation.
toggleEvents :: [Event -> Fay ()] -> JQuery -> Fay ()
toggleEvents = ffi "%2.toggle.apply(%2, %1)"


--
-- Event Handler Attachment
--

bind :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
bind = ffi "%3.bind(%1, %2)"

bindPreventBubble :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
bindPreventBubble = ffi "%3.bind(%1,%2,false)"

-- delegate() superceeded by on()
-- die() deprecated
-- live() deprecated
-- off() TODO how should this be handled?

on :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
on = ffi "%3.on(%1, %2)"

onDelegate :: EventType -> Selector -> (Event -> Fay()) -> JQuery -> Fay ()
onDelegate = ffi "%4.on(%1,%2,%3)"

one :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
one = ffi "%3.one(%1, %2)"

trigger :: EventType -> JQuery -> Fay ()
trigger = ffi "%2.trigger(%1)"

triggerHandler :: EventType -> JQuery -> Fay ()
triggerHandler = ffi "%2.triggerHandler(%1)"


-- unbind() not useful in Fay?
-- undelegate() not useful in Fay?

--
-- Event Object
--

-- event.data skipped

data Event
instance Foreign Event

delegateTarget :: Event -> Fay Element
delegateTarget = ffi "jQuery(%1.delegateTarget)"

isDefaultPrevented :: Event -> Fay Bool
isDefaultPrevented = ffi "%1.isDefaultPrevented()"

isImmediatePropagationStopped :: Event -> Fay Bool
isImmediatePropagationStopped = ffi "%1.isImmediatePropagationStopped()"

isPropagationStopped :: Event -> Fay Element
isPropagationStopped = ffi "%1.isPropagationStopped()"

namespace :: Event -> Fay String
namespace = ffi "%1.namespace"

pageX :: Event -> Fay Double
pageX = ffi "%1.pageX"

pageY :: Event -> Fay Double
pageY = ffi "%1.pageY"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1.preventDefault()"

target :: Event -> Fay Element
target = ffi "%1.target"

timeStamp :: Event -> Fay Double
timeStamp = ffi "%1.timeStamp"

eventType :: Event -> Fay String
eventType = ffi "%1.type"

which :: Event -> Fay Int
which = ffi "%1.which"

--
-- Form Events
--

blur :: (Event -> Fay ()) -> JQuery -> Fay ()
blur = ffi "%2.blur(%1)"

change :: (Event -> Fay ()) -> JQuery -> Fay ()
change = ffi "%2.change(%1)"

focus :: (Event -> Fay ()) -> JQuery -> Fay ()
focus = ffi "%2.focus(%1)"

-- TODO `select` would clash with the other select definition, should it be renamed?
onselect :: (Event -> Fay ()) -> JQuery -> Fay ()
onselect = ffi "%2.select(%1)"

submit  :: (Event -> Fay ()) -> JQuery -> Fay ()
submit = ffi "%2.submit(%1)"

--
-- Keyboard Events
--

keydown :: (Event -> Fay ()) -> JQuery -> Fay ()
keydown = ffi "%2.keydown(%1)"

keypress :: (Event -> Fay ()) -> JQuery -> Fay ()
keypress = ffi "%2.keypress(%1)"

keyup :: (Event -> Fay ()) -> JQuery -> Fay ()
keyup = ffi "%2.keyup(%1)"

----
---- Forms
----

----
---- Internals
----

----
---- Manipulation
----

-- Is there a better way to constrain the type here?
after :: (Foreign a) => a -> JQuery -> Fay JQuery
after = ffi "%2.after(%1)"

afterWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
afterWith = ffi "%2.after(%1)"

append :: (Foreign a) => a -> JQuery -> Fay JQuery
append = ffi "%2.append(%1)"

appendJQuery :: JQuery -> JQuery -> Fay JQuery
appendJQuery = ffi "%2.append(%1)"


appendWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
appendWith = ffi "%2.append(%1)"

appendTo :: (Foreign a) => a -> JQuery -> Fay JQuery
appendTo = ffi "%2.appendTo(%1)"

appendToJQuery :: JQuery -> JQuery -> Fay JQuery
appendToJQuery = ffi "%2.appendTo(%1)"



before :: (Foreign a) => a -> JQuery -> Fay JQuery
before = ffi "%2.before(%1)"

beforeWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
beforeWith = ffi "%2.before(%1)"

data CloneType = WithoutDataAndEvents | WithDataAndEvents | DeepWithDataAndEvents

clone :: CloneType -> JQuery -> Fay JQuery
clone WithoutDataAndEvents  = ffi "%2.clone(false)"
clone WithDataAndEvents     = ffi "%2.clone(true, false)"
clone DeepWithDataAndEvents = ffi "%2.clone(true, true)"

detach :: JQuery -> Fay JQuery
detach = ffi "%1.detach()"

detachSelector :: String -> JQuery -> Fay JQuery
detachSelector = ffi "%2.detach(%1)"

empty :: JQuery -> Fay JQuery
empty = ffi "%1.empty()"

insertAfter :: (Foreign a) => a -> JQuery -> Fay JQuery
insertAfter = ffi "%2.insertAfter(%1)"

insertBefore :: (Foreign a) => a -> JQuery -> Fay JQuery
insertBefore = ffi "%2.insertBefore(%1)"

prepend :: (Foreign a) => a -> JQuery -> Fay JQuery
prepend = ffi "%2.prepend(%1)"

prependWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
prependWith = ffi "%2.prepend(%1)"

prependTo :: (Foreign a) => a -> JQuery -> Fay JQuery
prependTo = ffi "%2.prependTo(%1)"

remove :: JQuery -> Fay JQuery
remove = ffi "%1.remove()"

removeSelector :: String -> JQuery -> Fay JQuery
removeSelector = ffi "%2.remove(%1)"

replaceAll :: String -> JQuery -> Fay JQuery
replaceAll = ffi "%2.replaceAll(%1)"

-- FIXME: create other forms of replaceWith
replaceWith :: String -> JQuery -> Fay JQuery
replaceWith = ffi "%2.replaceWith(%1)"

replaceWithJQuery :: JQuery -> JQuery -> Fay JQuery
replaceWithJQuery = ffi "%2.replaceWith(%1)"

-- FIXME: this name matches convention, but it's kind of silly
replaceWithWith :: (Fay JQuery) -> JQuery -> Fay JQuery
replaceWithWith = ffi "%2.replaceWith(%1)"

unwrap :: JQuery -> Fay JQuery
unwrap = ffi "%1.unwrap()"

-- FIXME: create other forms of wrap
wrap :: String -> JQuery -> Fay JQuery
wrap = ffi "%2.wrap(%1)"

wrapWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
wrapWith = ffi "%2.wrap(%1)"

wrapAllHtml :: String -> JQuery -> Fay JQuery
wrapAllHtml = ffi "%2.wrapAll(%1)"

wrapAllSelector :: String -> JQuery -> Fay JQuery
wrapAllSelector = ffi "%2.wrapAll(%1)"

wrapAllElement :: Element -> JQuery -> Fay JQuery
wrapAllElement = ffi "%2.wrapAll(%1)"

wrapInnerHtml :: String -> JQuery -> Fay JQuery
wrapInnerHtml = ffi "%2.wrapInner(%1)"

wrapInnerSelector :: String -> JQuery -> Fay JQuery
wrapInnerSelector = ffi "%2.wrapInner(%1)"

wrapInnerElement :: Element -> JQuery -> Fay JQuery
wrapInnerElement = ffi "%2.wrapInner(%1)"


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
addSelector = ffi "%2.add(%1)"

addElement :: Element -> JQuery -> Fay JQuery
addElement = ffi "%2.add(%1)"

addHtml :: String -> JQuery -> Fay JQuery
addHtml = ffi "%2.add(%1)"

add :: JQuery -> JQuery -> Fay JQuery
add = ffi "%2.add(%1)"

addSelectorWithContext :: String -> JQuery -> JQuery -> Fay JQuery
addSelectorWithContext = ffi "%3.add(%1, %2)"

andSelf :: JQuery -> Fay JQuery
andSelf = ffi "%1.andSelf()"

children :: JQuery -> Fay JQuery
children = ffi "%1.children()"

childrenMatching :: String -> JQuery -> Fay JQuery
childrenMatching = ffi "%2.children(%1)"

closestSelector :: String -> JQuery -> Fay JQuery
closestSelector = ffi "%2.closest(%1)"

-- TODO: is context really a string?
closestWithContext :: String -> String -> JQuery -> Fay JQuery
closestWithContext = ffi "%3.closest(%1, %2)"

closest :: JQuery -> JQuery -> Fay JQuery
closest = ffi "%2.closest(%1)"

closestElement :: Element -> JQuery -> Fay JQuery
closestElement = ffi "%2.closest(%1)"

-- TODO: include deprecated array-based signature?

contents :: JQuery -> Fay JQuery
contents = ffi "%1.contents()"

-- This just isn't cool. Can't we all just use map?
each :: (Double -> Element -> Fay Bool) -> JQuery -> Fay JQuery
each = ffi "%2.each(%1)"

end :: JQuery -> Fay JQuery
end = ffi "%1.end()"

eq :: Double -> JQuery -> Fay JQuery
eq = ffi "%2.eq(%1)"

filter :: String -> JQuery -> Fay JQuery
filter = ffi "%2.filter(%1)"

filterWith :: (Double -> Fay Bool) -> JQuery -> Fay JQuery
filterWith = ffi "%2.filter(%1)"

filterElement :: Element -> JQuery -> Fay JQuery
filterElement = ffi "%2.filter(%1)"

filterJQuery :: JQuery -> JQuery -> Fay JQuery
filterJQuery = ffi "%2.filter(%1)"

-- FIXME: not called find because Fay doesn't seem to deal well with name conflicts yet
findSelector :: String -> JQuery -> Fay JQuery
findSelector = ffi "%2.find(%1)"

findJQuery :: JQuery -> JQuery -> Fay JQuery
findJQuery = ffi "%2.find(%1)"

findElement :: Element -> JQuery -> Fay JQuery
findElement = ffi "%2.find(%1)"

first :: JQuery -> Fay JQuery
first = ffi "%1.first()"

has :: String -> JQuery -> Fay JQuery
has = ffi "%2.has(%1)"

hasElement :: Element -> JQuery -> Fay JQuery
hasElement = ffi "%2.has(%1)"

is :: String -> JQuery -> Fay JQuery
is = ffi "%2.is(%1)"

isWith :: (Double -> Bool) -> JQuery -> Fay JQuery
isWith = ffi "%2.is(%1)"

isJQuery :: JQuery -> JQuery -> Fay JQuery
isJQuery = ffi "%2.is(%1)"

isElement :: Element -> JQuery -> Fay JQuery
isElement = ffi "%2.is(%1)"

last :: JQuery -> Fay JQuery
last = ffi "%1.last()"

-- FIXME: is the return value of the callback right?
jQueryMap :: (Double -> Element -> Fay JQuery) -> JQuery -> Fay JQuery
jQueryMap = ffi "%2.map(%1)"

next :: JQuery -> Fay JQuery
next = ffi "%1.next()"

nextSelector :: String -> JQuery -> Fay JQuery
nextSelector = ffi "%2.next(%1)"

nextAll :: JQuery -> Fay JQuery
nextAll = ffi "%1.nextAll()"

nextAllSelector :: String -> JQuery -> Fay JQuery
nextAllSelector = ffi "%2.nextAll(%1)"

nextUntil :: String -> JQuery -> Fay JQuery
nextUntil = ffi "%2.nextUntil(%1)"

nextUntilFiltered :: String -> String -> JQuery -> Fay JQuery
nextUntilFiltered = ffi "%3.nextUntil(%1, %2)"

nextUntilElement :: Element -> JQuery -> Fay JQuery
nextUntilElement = ffi "%2.nextUntil(%1)"

nextUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
nextUntilElementFiltered = ffi "%3.nextUntil(%1, %2)"

not :: String -> JQuery -> Fay JQuery
not = ffi "%2.not(%1)"

notElement :: Element -> JQuery -> Fay JQuery
notElement = ffi "%2.not(%1)"

notElements :: [Element] -> JQuery -> Fay JQuery
notElements = ffi "%2.not(%1)"

notWith :: (Double -> Bool) -> JQuery -> Fay JQuery
notWith = ffi "%2.not(%1)"

notJQuery :: JQuery -> JQuery -> Fay JQuery
notJQuery = ffi "%2.not(%1)"

offsetParent :: JQuery -> Fay JQuery
offsetParent = ffi "%1.offsetParent()"

parent :: JQuery -> Fay JQuery
parent = ffi "%1.parent()"

parentSelector :: String -> JQuery -> Fay JQuery
parentSelector = ffi "%2.parent(%1)"

parents :: JQuery -> Fay JQuery
parents = ffi "%1.parents()"

parentsSelector :: String -> JQuery -> Fay JQuery
parentsSelector = ffi "%2.parents(%1)"

parentsUntil :: String -> JQuery -> Fay JQuery
parentsUntil = ffi "%2.parentsUntil(%1)"

parentsUntilFiltered :: String -> String -> JQuery -> Fay JQuery
parentsUntilFiltered = ffi "%3.parentsUntil(%1, %2)"

parentsUntilElement :: Element -> JQuery -> Fay JQuery
parentsUntilElement = ffi "%2.parentsUntil(%1)"

parentsUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
parentsUntilElementFiltered = ffi "%3.parentsUntil(%1, %2)"

prev :: JQuery -> Fay JQuery
prev = ffi "%1.prev()"

prevSelector :: String -> JQuery -> Fay JQuery
prevSelector = ffi "%2.prev(%1)"

prevAll :: JQuery -> Fay JQuery
prevAll = ffi "%1.prevAll()"

prevAllSelector :: String -> JQuery -> Fay JQuery
prevAllSelector = ffi "%2.prevAll(%1)"

prevUntil :: String -> JQuery -> Fay JQuery
prevUntil = ffi "%2.prevUntil(%1)"

prevUntilFiltered :: String -> String -> JQuery -> Fay JQuery
prevUntilFiltered = ffi "%3.prevUntil(%1, %2)"

prevUntilElement :: Element -> JQuery -> Fay JQuery
prevUntilElement = ffi "%2.prevUntil(%1)"

prevUntilElementFiltered :: Element -> String -> JQuery -> Fay JQuery
prevUntilElementFiltered = ffi "%3.prevUntil(%1, %2)"

siblings :: JQuery -> Fay JQuery
siblings = ffi "%1.siblings()"

siblingsSelector :: String -> JQuery -> Fay JQuery
siblingsSelector = ffi "%2.siblings(%1)"

slice :: Double -> JQuery -> Fay JQuery
slice = ffi "%2.slice(%1)"

sliceFromTo :: Double -> Double -> JQuery -> Fay JQuery
sliceFromTo = ffi "%3.slice(%1, %2)"







-- vim implementation shortcut
-- inoremap <F6> <ESC>:normal 0ywo<ESC>pa= ffi ""<ESC>F"i



----
---- Utilities
----
