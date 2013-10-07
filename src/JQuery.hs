{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE RebindableSyntax  #-}
{-# LANGUAGE TypeSynonymInstances #-}

module JQuery where

{--
Note that this is very much in flux. Function names, type signatures, and
data types all subject to drastic change.
--}

import           Fay.Text
import           FFI
import           Prelude hiding (succ)

data JQuery

data JQXHR

type EventType = Text

type Selector = Text


-- Things that should go in fay or fay-dom
data Element

data Document

data Window

data Object

emptyCallback :: a -> Fay ()
emptyCallback = const $ return ()

----
---- Ajax
----

ajax :: Text
     -> (Automatic b -> Fay ())
     -> (JQXHR -> Maybe Text -> Maybe Text -> Fay ())
     -> Fay ()
ajax ur succ err = ajax' $ defaultAjaxSettings
  { success = Defined succ
  , data' = Undefined :: Defined Text -- hackety hack
  , error' = Defined err
  , url = Defined ur }

-- | Serializes the given object to JSON and passes it as the request body without request parameters.
--   The response is deserialized depending on its type.
ajaxPost :: Text
         -> Automatic f
         -> (Automatic g -> Fay ())
         -> (JQXHR -> Maybe Text -> Maybe Text -> Fay ())
         -> Fay ()
ajaxPost ur dat succ err = ajax' $ defaultAjaxSettings
  { success = Defined succ
  , data' = Defined dat
  , error' = Defined err
  , url = Defined ur
  , type' = Defined "POST"
  , processData = Defined False
  , contentType = Defined "text/json"
  , dataType = Defined "json"
  }

-- | Same as ajaxPost but sends the data inside the given request parameter
ajaxPostParam :: Text
              -> Text
              -> Automatic f
              -> (Automatic g -> Fay ())
              -> (JQXHR -> Maybe Text -> Maybe Text -> Fay ())
              -> Fay ()
ajaxPostParam ur rqparam dat succ err = ajax' $ defaultAjaxSettings
  { success = Defined succ
  , data' = Defined $ makeRqObj rqparam dat
  , error' = Defined err
  , url = Defined ur
  , type' = Defined "POST"
  , processData = Defined False
  , contentType = Defined "text/json"
  , dataType = Defined "json"
  }

makeRqObj :: Text -> a -> Object
makeRqObj = ffi "(function () { var o = {}; o[%1] = %2; return o; })()"

data AjaxSettings a b = AjaxSettings
  { accepts     :: Defined Text
  , async       :: Defined Bool
  , beforeSend  :: Defined (JQXHR -> AjaxSettings a b -> Fay ())
  , cache       :: Defined Bool
  , complete    :: Defined (JQXHR -> Text -> Fay ())
  -- , contents :: Defined (Object RegExp) -- skipped
  , contentType :: Defined Text
  -- , context :: Defined Object -- skipped
  -- , converters :: Defined (Object Value) -- skipped
  , crossDomain :: Defined Bool
  , data'       :: Defined a
  -- , dataFilter  :: Defined (Data -> Type -> Fay ()) -- skipped
  , dataType    :: Defined Text
  , error'      :: Defined (JQXHR -> Maybe Text -> Maybe Text -> Fay ())
  , global      :: Defined Bool
  -- , headers :: Object Text -- need generic objects
  , ifModified  :: Defined Bool
  , isLocal     :: Defined Bool
  -- , jsonp -- skipped
  -- , jsonpCallback -- skipped
  , mimeType    :: Defined Text
  , password    :: Defined Text
  , processData :: Defined Bool
  -- , scriptCharset -- skipped
  -- , statusCode -- skipped
  , success     :: Defined (b -> Fay ())
  , timeout     :: Defined Double
  -- , traditional -- skipped
  , type'       :: Defined Text
  , url         :: Defined Text
  , username    :: Defined Text
  -- , xhr :: XHR -- XHR needs to be added to fay-dom
  }

defaultAjaxSettings :: AjaxSettings a b
defaultAjaxSettings = AjaxSettings
  { accepts     = Undefined
  , async       = Undefined
  , beforeSend  = Undefined
  , cache       = Undefined
  , complete    = Undefined
  , contentType = Undefined
  , crossDomain = Undefined
  , data'       = Undefined
  , dataType    = Undefined
  , error'      = Undefined
  , global      = Undefined
  , ifModified  = Undefined
  , isLocal     = Undefined
  , mimeType    = Undefined
  , password    = Undefined
  , processData = Undefined
  , success     = Undefined
  , timeout     = Undefined
  , type'       = Undefined
  , url         = Undefined
  , username    = Undefined
  }

ajax' :: AjaxSettings (Automatic a) (Automatic b) -> Fay ()
ajax' = ffi "\
  \ (function (o) { \
    \ delete o['instance']; \
    \ for (var p in o) { \
      \ if (/\\$39\\$/.test(p)) { \
        \ o[p.replace(/\\$39\\$/g, '')] = o[p]; \
        \ delete o[p]; \
      \ } \
    \ } \
    \ return jQuery.ajax(o); \
  \ })(%1)"

----
---- Attributes
----

addClass :: Text -> JQuery -> Fay JQuery
addClass = ffi "%2['addClass'](%1)"

-- FIXME: https://github.com/chrisdone/fay/issues/38
addClassWith :: (Double -> Text -> Fay Text) -> JQuery -> Fay JQuery
addClassWith = ffi "%2['addClass'](%1)"

getAttr :: Text -> JQuery -> Fay Text
getAttr = ffi "%2['attr'](%1)"

setAttr :: Text -> Text -> JQuery -> Fay JQuery
setAttr = ffi "%3['attr'](%1, %2)"

-- TODO: setAttrs with map

setAttrWith :: Text -> (Double -> Text -> Fay Text) -> JQuery -> Fay JQuery
setAttrWith = ffi "%3['attr'](%1, %2)"

hasClass :: Text -> JQuery -> Fay Bool
hasClass = ffi "%2['hasClass'](%1)"

getHtml :: JQuery -> Fay Text
getHtml = ffi "%1['html']()"

setHtml :: Text -> JQuery -> Fay JQuery
setHtml = ffi "%2['html'](%1)"

setHtmlWith :: (Double -> Text -> Fay JQuery) -> JQuery -> Fay JQuery
setHtmlWith = ffi "%2['html'](%1)"

-- TODO: html with props

getProp :: Text -> JQuery -> Fay Text
getProp = ffi "%2['prop'](%1)"

setProp :: Text -> Text -> JQuery -> Fay JQuery
setProp = ffi "%3['prop'](%1, %2)"

-- TODO: setProp with map

setPropWith :: Text -> (Double -> Text -> Fay Text) -> JQuery -> Fay JQuery
setPropWith = ffi "%3['prop'](%1, %2)"

removeAttr :: Text -> JQuery -> Fay JQuery
removeAttr = ffi "%2['removeAttr'](%1)"

removeClass :: Text -> JQuery -> Fay JQuery
removeClass = ffi "%2['removeClass'](%1)"

removeClassWith :: (Double -> Text -> Fay JQuery) -> JQuery -> Fay JQuery
removeClassWith = ffi "%2['removeClass'](%1)"

removeProp :: Text -> JQuery -> Fay JQuery
removeProp = ffi "%2['removeProp'](%1)"

toggleClass :: Text -> JQuery -> Fay JQuery
toggleClass = ffi "%2['toggleClass'](%1)"

toggleClassBool :: Text -> Bool -> JQuery -> Fay JQuery
toggleClassBool = ffi "%3['toggleClass'](%1, %2)"

toggleAllClasses :: Bool -> JQuery -> Fay JQuery
toggleAllClasses = ffi "%2['toggleClass'](%1)"

toggleClassWith :: (Double -> Text -> Bool -> Fay JQuery) -> JQuery -> Fay JQuery
toggleClassWith = ffi "%2['toggleClass'](%1)"

toggleClassBoolWith :: (Double -> Text -> Bool -> Fay JQuery) -> Bool -> JQuery -> Fay JQuery
toggleClassBoolWith = ffi "%3['toggleClass'](%1, %2)"

getVal :: JQuery -> Fay Text
getVal = ffi "%1['val']()"

setVal :: Text -> JQuery -> Fay JQuery
setVal = ffi "%2['val'](%1)"

setValWith :: (Double -> Text -> Fay JQuery) -> JQuery -> Fay JQuery
setValWith = ffi "%2['val'](%1)"

setText :: Text -> JQuery -> Fay JQuery
setText = ffi "%2['text'](%1)"

setTextWith :: (Double -> Text -> Fay JQuery) -> JQuery -> Fay JQuery
setTextWith = ffi "%2['text'](%1)"

getText :: JQuery -> Fay Text
getText = ffi "%1['text']()"

----
---- Core
----

holdReady :: Bool -> Fay JQuery
holdReady = ffi "jQuery['holdReady'](%1)"

-- jQuery()
-- http://api.jquery.com/jQuery/
class Selectable a

instance Selectable Text
instance Selectable Element
instance Selectable JQuery

select :: Selectable a => a -> Fay JQuery
select = ffi "jQuery(%1)"

selectEmpty :: Fay JQuery
selectEmpty = ffi "jQuery()"

selectInContext :: (Selectable a, Selectable b) => a -> b -> Fay JQuery
selectInContext = ffi "jQuery(%1, %2)"

ready :: Fay () -> Fay ()
ready = ffi "jQuery(%1)"
-- end jQuery()

-- is noConflict useful in the context of Fay?
noConflict :: Fay JQuery
noConflict = ffi "jQuery['noConflict']()"

noConflictBool :: Bool -> Fay JQuery
noConflictBool = ffi "jQuery['noConflict'](%1)"

-- TODO: jQuery['sub']()

-- TODO: jQuery['when'](): figure out Deferred first

----
---- CSS
----

getCss :: Text -> JQuery -> Fay Text
getCss = ffi "%2['css'](%1)"

setCss :: Text -> Text -> JQuery -> Fay JQuery
setCss = ffi "%3['css'](%1, %2)"

setCssWith :: Text -> (Double -> Text -> Fay Text) -> JQuery -> Fay JQuery
setCssWith = ffi "%3['css'](%1, %2)"

getHeight :: JQuery -> Fay Double
getHeight = ffi "%1['height']()"

setHeight :: Double -> JQuery -> Fay JQuery
setHeight = ffi "%2['height'](%1)"

setHeightWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
setHeightWith = ffi "%2['height'](%1)"

getInnerHeight :: JQuery -> Fay Double
getInnerHeight = ffi "%1['innerHeight']()"

getInnerWidth :: JQuery -> Fay Double
getInnerWidth = ffi "%1['innerWidth']()"

-- TODO: figure out how to marshal coordinates
--getOffset :: JQuery -> Fay
--getOffset = ffi "%1['offset']()"

--setOffset
--setOffsetWith

-- TODO: css with map

-- TODO: cssHooks

getOuterHeight :: JQuery -> Fay Double
getOuterHeight = ffi "%1['outerHeight']()"

-- FIXME: better name
getOuterHeightBool :: Bool -> JQuery -> Fay Double
getOuterHeightBool = ffi "%2['outerHeight'](%1)"

getOuterWidth :: JQuery -> Fay Double
getOuterWidth = ffi "%1['outerWidth']()"

getOuterWidthBool :: Bool -> JQuery -> Fay Double
getOuterWidthBool = ffi "%2['outerWidth'](%1)"

-- TODO: marshal coordinates as in offset()
-- getPosition

getScrollLeft :: JQuery -> Fay Double
getScrollLeft = ffi "%1['scrollLeft']()"

setScrollLeft :: Double -> JQuery -> Fay JQuery
setScrollLeft = ffi "%2['scrollLeft'](%1)"

getScrollTop :: JQuery -> Fay Double
getScrollTop = ffi "%1['scrollTop']()"

setScrollTop :: Double -> JQuery -> Fay JQuery
setScrollTop = ffi "%2['scrollTop'](%1)"

getWidth :: JQuery -> Fay Double
getWidth = ffi "%1['width']()"

setWidth :: Double -> JQuery -> Fay JQuery
setWidth = ffi "%2['width'](%1)"

setWidthWith :: (Double -> Double -> Fay Double) -> JQuery -> Fay JQuery
setWidthWith = ffi "%2['width'](%1)"


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

data AnimationType = Show | Hide | Toggle | FadeIn | FadeOut | FadeToggle

data Speed = Instantly | Slow | Fast | Speed Double

data Animation = Animation
  { _type          :: AnimationType
  , _speed         :: Speed
  , _nextAnimation :: Maybe Animation
  , _element       :: JQuery
  }

anim :: AnimationType -> JQuery -> Animation
anim ty el = Animation ty Fast Nothing el

speed :: Speed -> Animation -> Animation
speed spd ani = ani { _speed = spd }

chainAnim :: Animation -> Animation -> Animation
chainAnim a1 a2 = a1 { _nextAnimation = Just a2 }

chainAnims :: [Animation] -> Animation
chainAnims [a] = a
chainAnims (a:as) = a `chainAnim` chainAnims as
chainAnims [] = error (unpack "chainAnims: empty list")

runAnimation :: Animation -> Fay ()
runAnimation a = do
  animate (_type a) (_speed a) cb (_element a) >> return ()
    where
      cb = case _nextAnimation a of
                Just a2 -> const (runAnimation a2)
                Nothing -> const (return ())

animate :: AnimationType -> Speed -> (JQuery -> Fay ()) -> JQuery -> Fay JQuery
animate = ffi "%4[(function () { \
      \ switch (%1['instance']) { \
        \ case 'FadeIn': return 'fadeIn'; \
        \ case 'FadeOut': return 'fadeOut'; \
        \ case 'FadeToggle': return 'fadeToggle'; \
        \ default: return %1['instance']['toLowerCase'](); \
      \ } \
    \ })()]((function () { \
    \ if (%2['instance'] == 'Slow') { \
      \ return 'slow'; \
    \ } else if (%2['instance'] == 'Instantly') { \
      \ return null; \
    \ } else if (%2['instance'] == 'Fast') { \
      \ return 'fast'; \
    \ } else { \
      \ return %2['slot1']; \
    \ } \
  \ })(), function() { \
     \ %3(jQuery(this)); \
  \ })"

hide :: Speed -> JQuery -> Fay JQuery
hide spd = animate Hide spd emptyCallback

unhide :: JQuery -> Fay JQuery
unhide = ffi "%1['show']()"

jshow :: Speed -> JQuery -> Fay JQuery
jshow spd = animate Show spd emptyCallback

toggle :: Speed -> JQuery -> Fay JQuery
toggle spd = animate Toggle spd emptyCallback

--
-- Fading
--

fadeIn :: Speed -> JQuery -> Fay JQuery
fadeIn spd = animate FadeIn spd emptyCallback

fadeOut :: Speed -> JQuery -> Fay JQuery
fadeOut spd = animate FadeOut spd emptyCallback

-- TODO fadeTo

fadeToggle :: Speed -> JQuery -> Fay JQuery
fadeToggle spd = animate FadeToggle spd emptyCallback

----
---- Events
----

--
-- Browser Events
--

-- Skip error(), deprecated

resize :: (Event -> Fay ()) -> JQuery -> Fay ()
resize = ffi "%2['resize'](%1)"

scroll :: (Event -> Fay ()) -> JQuery -> Fay ()
scroll = ffi "%2['scroll'](%1)"

--
-- Document Loading
--

load :: (Event -> Fay()) -> JQuery -> Fay ()
load = ffi "%2['load'](%1)"

documentReady :: (Event -> Fay ()) -> Document -> Fay ()
documentReady = ffi "jQuery(%2)['ready'](%1)"

unload :: (Event -> Fay()) -> Window -> Fay ()
unload = ffi "jQuery(%2)['unload'](%1)"

--
-- Mouse Events
--

click :: (Event -> Fay ()) -> JQuery -> Fay JQuery
click = ffi "%2['click'](%1)"

dblclick :: (Event -> Fay ()) -> JQuery -> Fay JQuery
dblclick = ffi "%2['dblclick'](%1)"

focusin :: (Event -> Fay ()) -> JQuery -> Fay JQuery
focusin = ffi "%2['focusin'](%1)"

focusout :: (Event -> Fay ()) -> JQuery -> Fay JQuery
focusout = ffi "%2['focusout'](%1)"

hover :: (Event -> Fay ()) -> JQuery -> Fay JQuery
hover = ffi "%2['hover'](%1)"

mousedown :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mousedown = ffi "%2['mousedown'](%1)"

mouseenter :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mouseenter = ffi "%2['mouseenter'](%1)"

mouseleave :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mouseleave = ffi "%2['mouseleave'](%1)"

mousemove :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mousemove = ffi "%2['mousemove'](%1)"

mouseout :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mouseout = ffi "%2['mouseout'](%1)"

mouseover :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mouseover = ffi "%2['mouseover'](%1)"

mouseup :: (Event -> Fay ()) -> JQuery -> Fay JQuery
mouseup = ffi "%2['mouseup'](%1)"

-- Argument splat since an arbitrary number of events can be attached.
-- `toggle` in jQuery but clashes with the `toggle` animation.
toggleEvents :: [Event -> Fay ()] -> JQuery -> Fay ()
toggleEvents = ffi "%2['toggle']['apply'](%2, %1)"


--
-- Event Handler Attachment
--

bind :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
bind = ffi "%3['bind'](%1, %2)"

bindPreventBubble :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
bindPreventBubble = ffi "%3['bind'](%1,%2,false)"

-- delegate() superceeded by on()
-- die() deprecated
-- live() deprecated
-- off() TODO how should this be handled?

on :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
on = ffi "%3['on'](%1, %2)"

onDelegate :: EventType -> Selector -> (Event -> Fay()) -> JQuery -> Fay ()
onDelegate = ffi "%4['on'](%1,%2,%3)"

one :: EventType -> (Event -> Fay ()) -> JQuery -> Fay ()
one = ffi "%3['one'](%1, %2)"

trigger :: EventType -> JQuery -> Fay ()
trigger = ffi "%2['trigger'](%1)"

triggerHandler :: EventType -> JQuery -> Fay ()
triggerHandler = ffi "%2['triggerHandler'](%1)"


-- unbind() not useful in Fay?
-- undelegate() not useful in Fay?

--
-- Event Object
--

-- event.data skipped

data Event

delegateTarget :: Event -> Fay Element
delegateTarget = ffi "jQuery(%1['delegateTarget'])"

isDefaultPrevented :: Event -> Fay Bool
isDefaultPrevented = ffi "%1['isDefaultPrevented']()"

isImmediatePropagationStopped :: Event -> Fay Bool
isImmediatePropagationStopped = ffi "%1['isImmediatePropagationStopped']()"

isPropagationStopped :: Event -> Fay Element
isPropagationStopped = ffi "%1['isPropagationStopped']()"

namespace :: Event -> Fay Text
namespace = ffi "%1['namespace']"

pageX :: Event -> Fay Double
pageX = ffi "%1['pageX']"

pageY :: Event -> Fay Double
pageY = ffi "%1['pageY']"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1['preventDefault']()"

target :: Event -> Fay Element
target = ffi "%1['target']"

timeStamp :: Event -> Fay Double
timeStamp = ffi "%1['timeStamp']"

eventType :: Event -> Fay Text
eventType = ffi "%1['type']"

which :: Event -> Fay Int
which = ffi "%1['which']"

--
-- Form Events
--

blur :: (Event -> Fay ()) -> JQuery -> Fay ()
blur = ffi "%2['blur'](%1)"

change :: (Event -> Fay ()) -> JQuery -> Fay ()
change = ffi "%2['change'](%1)"

onFocus :: (Event -> Fay ()) -> JQuery -> Fay ()
onFocus = ffi "%2['focus'](%1)"

focus :: JQuery -> Fay JQuery
focus = ffi "%1['focus']()"

-- TODO `select` would clash with the other select definition, should it be renamed?
onselect :: (Event -> Fay ()) -> JQuery -> Fay ()
onselect = ffi "%2['select'](%1)"

submit  :: (Event -> Fay ()) -> JQuery -> Fay ()
submit = ffi "%2['submit'](%1)"

--
-- Keyboard Events
--

keydown :: (Event -> Fay ()) -> JQuery -> Fay ()
keydown = ffi "%2['keydown'](%1)"

keypress :: (Event -> Fay ()) -> JQuery -> Fay ()
keypress = ffi "%2['keypress'](%1)"

keyup :: (Event -> Fay ()) -> JQuery -> Fay ()
keyup = ffi "%2['keyup'](%1)"

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
after :: a -> JQuery -> Fay JQuery
after = ffi "%2['after'](%1)"

afterWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
afterWith = ffi "%2['after'](%1)"

append :: a -> JQuery -> Fay JQuery
append = ffi "%2['append'](%1)"

appendJQuery :: JQuery -> JQuery -> Fay JQuery
appendJQuery = ffi "%2['append'](%1)"


appendWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
appendWith = ffi "%2['append'](%1)"

appendTo :: a -> JQuery -> Fay JQuery
appendTo = ffi "%2['appendTo'](%1)"

appendToJQuery :: JQuery -> JQuery -> Fay JQuery
appendToJQuery = ffi "%2['appendTo'](%1)"



before :: a -> JQuery -> Fay JQuery
before = ffi "%2['before'](%1)"

beforeWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
beforeWith = ffi "%2['before'](%1)"

data CloneType = WithoutDataAndEvents | WithDataAndEvents | DeepWithDataAndEvents

clone :: CloneType -> JQuery -> Fay JQuery
clone WithoutDataAndEvents  = ffi "%1['clone'](false)"       :: JQuery -> Fay JQuery
clone WithDataAndEvents     = ffi "%1['clone'](true, false)" :: JQuery -> Fay JQuery
clone DeepWithDataAndEvents = ffi "%1['clone'](true, true)"  :: JQuery -> Fay JQuery


detach :: JQuery -> Fay JQuery
detach = ffi "%1['detach']()"

detachSelector :: Text -> JQuery -> Fay JQuery
detachSelector = ffi "%2['detach'](%1)"

empty :: JQuery -> Fay JQuery
empty = ffi "%1['empty']()"

insertAfter :: a -> JQuery -> Fay JQuery
insertAfter = ffi "%2['insertAfter'](%1)"

insertBefore :: a -> JQuery -> Fay JQuery
insertBefore = ffi "%2['insertBefore'](%1)"

prepend :: a -> JQuery -> Fay JQuery
prepend = ffi "%2['prepend'](%1)"

prependWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
prependWith = ffi "%2['prepend'](%1)"

prependTo :: a -> JQuery -> Fay JQuery
prependTo = ffi "%2['prependTo'](%1)"

remove :: JQuery -> Fay JQuery
remove = ffi "%1['remove']()"

removeSelector :: Text -> JQuery -> Fay JQuery
removeSelector = ffi "%2['remove'](%1)"

replaceAll :: Text -> JQuery -> Fay JQuery
replaceAll = ffi "%2['replaceAll'](%1)"

-- FIXME: create other forms of replaceWith
replaceWith :: Text -> JQuery -> Fay JQuery
replaceWith = ffi "%2['replaceWith'](%1)"

replaceWithJQuery :: JQuery -> JQuery -> Fay JQuery
replaceWithJQuery = ffi "%2['replaceWith'](%1)"

-- FIXME: this name matches convention, but it's kind of silly
replaceWithWith :: (Fay JQuery) -> JQuery -> Fay JQuery
replaceWithWith = ffi "%2['replaceWith'](%1)"

unwrap :: JQuery -> Fay JQuery
unwrap = ffi "%1['unwrap']()"

-- FIXME: create other forms of wrap
wrap :: Text -> JQuery -> Fay JQuery
wrap = ffi "%2['wrap'](%1)"

wrapWith :: (Double -> Fay JQuery) -> JQuery -> Fay JQuery
wrapWith = ffi "%2['wrap'](%1)"

wrapAllHtml :: Text -> JQuery -> Fay JQuery
wrapAllHtml = ffi "%2['wrapAll'](%1)"

wrapAllSelector :: Text -> JQuery -> Fay JQuery
wrapAllSelector = ffi "%2['wrapAll'](%1)"

wrapAllElement :: Element -> JQuery -> Fay JQuery
wrapAllElement = ffi "%2['wrapAll'](%1)"

wrapInnerHtml :: Text -> JQuery -> Fay JQuery
wrapInnerHtml = ffi "%2['wrapInner'](%1)"

wrapInnerSelector :: Text -> JQuery -> Fay JQuery
wrapInnerSelector = ffi "%2['wrapInner'](%1)"

wrapInnerElement :: Element -> JQuery -> Fay JQuery
wrapInnerElement = ffi "%2['wrapInner'](%1)"


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
addSelector :: Text -> JQuery -> Fay JQuery
addSelector = ffi "%2['add'](%1)"

addElement :: Element -> JQuery -> Fay JQuery
addElement = ffi "%2['add'](%1)"

addHtml :: Text -> JQuery -> Fay JQuery
addHtml = ffi "%2['add'](%1)"

add :: JQuery -> JQuery -> Fay JQuery
add = ffi "%2['add'](%1)"

addSelectorWithContext :: Text -> JQuery -> JQuery -> Fay JQuery
addSelectorWithContext = ffi "%3['add'](%1, %2)"

andSelf :: JQuery -> Fay JQuery
andSelf = ffi "%1['andSelf']()"

children :: JQuery -> Fay JQuery
children = ffi "%1['children']()"

childrenMatching :: Text -> JQuery -> Fay JQuery
childrenMatching = ffi "%2['children'](%1)"

closestSelector :: Text -> JQuery -> Fay JQuery
closestSelector = ffi "%2['closest'](%1)"

-- TODO: is context really a string?
closestWithContext :: Text -> Text -> JQuery -> Fay JQuery
closestWithContext = ffi "%3['closest'](%1, %2)"

closest :: JQuery -> JQuery -> Fay JQuery
closest = ffi "%2['closest'](%1)"

closestElement :: Element -> JQuery -> Fay JQuery
closestElement = ffi "%2['closest'](%1)"

-- TODO: include deprecated array-based signature?

contents :: JQuery -> Fay JQuery
contents = ffi "%1['contents']()"

-- This just isn't cool[' Can']'t we all just use map?
each :: (Double -> Element -> Fay Bool) -> JQuery -> Fay JQuery
each = ffi "%2['each'](%1)"

end :: JQuery -> Fay JQuery
end = ffi "%1['end']()"

eq :: Double -> JQuery -> Fay JQuery
eq = ffi "%2['eq'](%1)"

filter :: Text -> JQuery -> Fay JQuery
filter = ffi "%2['filter'](%1)"

filterWith :: (Double -> Fay Bool) -> JQuery -> Fay JQuery
filterWith = ffi "%2['filter'](%1)"

filterElement :: Element -> JQuery -> Fay JQuery
filterElement = ffi "%2['filter'](%1)"

filterJQuery :: JQuery -> JQuery -> Fay JQuery
filterJQuery = ffi "%2['filter'](%1)"

-- FIXME: not called find because Fay doesn't seem to deal well with name conflicts yet
findSelector :: Text -> JQuery -> Fay JQuery
findSelector = ffi "%2['find'](%1)"

findJQuery :: JQuery -> JQuery -> Fay JQuery
findJQuery = ffi "%2['find'](%1)"

findElement :: Element -> JQuery -> Fay JQuery
findElement = ffi "%2['find'](%1)"

first :: JQuery -> Fay JQuery
first = ffi "%1['first']()"

has :: Text -> JQuery -> Fay JQuery
has = ffi "%2['has'](%1)"

hasElement :: Element -> JQuery -> Fay JQuery
hasElement = ffi "%2['has'](%1)"

is :: Text -> JQuery -> Fay Bool
is = ffi "%2['is'](%1)"

isWith :: (Double -> Bool) -> JQuery -> Fay JQuery
isWith = ffi "%2['is'](%1)"

isJQuery :: JQuery -> JQuery -> Fay Bool
isJQuery = ffi "%2['is'](%1)"

isElement :: Element -> JQuery -> Fay Bool
isElement = ffi "%2['is'](%1)"

last :: JQuery -> Fay JQuery
last = ffi "%1['last']()"

-- FIXME: is the return value of the callback right?
jQueryMap :: (Double -> Element -> Fay JQuery) -> JQuery -> Fay JQuery
jQueryMap = ffi "%2['map'](%1)"

next :: JQuery -> Fay JQuery
next = ffi "%1['next']()"

nextSelector :: Text -> JQuery -> Fay JQuery
nextSelector = ffi "%2['next'](%1)"

nextAll :: JQuery -> Fay JQuery
nextAll = ffi "%1['nextAll']()"

nextAllSelector :: Text -> JQuery -> Fay JQuery
nextAllSelector = ffi "%2['nextAll'](%1)"

nextUntil :: Text -> JQuery -> Fay JQuery
nextUntil = ffi "%2['nextUntil'](%1)"

nextUntilFiltered :: Text -> Text -> JQuery -> Fay JQuery
nextUntilFiltered = ffi "%3['nextUntil'](%1, %2)"

nextUntilElement :: Element -> JQuery -> Fay JQuery
nextUntilElement = ffi "%2['nextUntil'](%1)"

nextUntilElementFiltered :: Element -> Text -> JQuery -> Fay JQuery
nextUntilElementFiltered = ffi "%3['nextUntil'](%1, %2)"

not :: Text -> JQuery -> Fay JQuery
not = ffi "%2['not'](%1)"

notElement :: Element -> JQuery -> Fay JQuery
notElement = ffi "%2['not'](%1)"

notElements :: [Element] -> JQuery -> Fay JQuery
notElements = ffi "%2['not'](%1)"

notWith :: (Double -> Bool) -> JQuery -> Fay JQuery
notWith = ffi "%2['not'](%1)"

notJQuery :: JQuery -> JQuery -> Fay JQuery
notJQuery = ffi "%2['not'](%1)"

offsetParent :: JQuery -> Fay JQuery
offsetParent = ffi "%1['offsetParent']()"

parent :: JQuery -> Fay JQuery
parent = ffi "%1['parent']()"

parentSelector :: Text -> JQuery -> Fay JQuery
parentSelector = ffi "%2['parent'](%1)"

parents :: JQuery -> Fay JQuery
parents = ffi "%1['parents']()"

parentsSelector :: Text -> JQuery -> Fay JQuery
parentsSelector = ffi "%2['parents'](%1)"

parentsUntil :: Text -> JQuery -> Fay JQuery
parentsUntil = ffi "%2['parentsUntil'](%1)"

parentsUntilFiltered :: Text -> Text -> JQuery -> Fay JQuery
parentsUntilFiltered = ffi "%3['parentsUntil'](%1, %2)"

parentsUntilElement :: Element -> JQuery -> Fay JQuery
parentsUntilElement = ffi "%2['parentsUntil'](%1)"

parentsUntilElementFiltered :: Element -> Text -> JQuery -> Fay JQuery
parentsUntilElementFiltered = ffi "%3['parentsUntil'](%1, %2)"

prev :: JQuery -> Fay JQuery
prev = ffi "%1['prev']()"

prevSelector :: Text -> JQuery -> Fay JQuery
prevSelector = ffi "%2['prev'](%1)"

prevAll :: JQuery -> Fay JQuery
prevAll = ffi "%1['prevAll']()"

prevAllSelector :: Text -> JQuery -> Fay JQuery
prevAllSelector = ffi "%2['prevAll'](%1)"

prevUntil :: Text -> JQuery -> Fay JQuery
prevUntil = ffi "%2['prevUntil'](%1)"

prevUntilFiltered :: Text -> Text -> JQuery -> Fay JQuery
prevUntilFiltered = ffi "%3['prevUntil'](%1, %2)"

prevUntilElement :: Element -> JQuery -> Fay JQuery
prevUntilElement = ffi "%2['prevUntil'](%1)"

prevUntilElementFiltered :: Element -> Text -> JQuery -> Fay JQuery
prevUntilElementFiltered = ffi "%3['prevUntil'](%1, %2)"

siblings :: JQuery -> Fay JQuery
siblings = ffi "%1['siblings']()"

siblingsSelector :: Text -> JQuery -> Fay JQuery
siblingsSelector = ffi "%2['siblings'](%1)"

slice :: Double -> JQuery -> Fay JQuery
slice = ffi "%2['slice'](%1)"

sliceFromTo :: Double -> Double -> JQuery -> Fay JQuery
sliceFromTo = ffi "%3['slice'](%1, %2)"

data KeyCode = KeyUp
             | KeyDown
             | KeyLeft
             | KeyRight
             | KeyRet
             | SomeKey Double
--  deriving (Show)

onKeycode :: (KeyCode -> Fay Bool) -> JQuery -> Fay JQuery
onKeycode callback el = do
  _onKeycode (\code -> callback (case code of
                                   38 -> KeyUp
                                   40 -> KeyDown
                                   37 -> KeyLeft
                                   39 -> KeyRight
                                   13 -> KeyRet
                                   _  -> SomeKey code))
             el

_onKeycode :: (Double -> Fay Bool) -> JQuery -> Fay JQuery
_onKeycode = ffi "%2['keycode'](%1)"

unKeycode :: JQuery -> Fay JQuery
unKeycode = ffi "%1['unkeycode']()"

onClick :: (Event -> Fay Bool) -> JQuery -> Fay JQuery
onClick = ffi "%2['click'](%1)"

onChange :: (Fay ()) -> JQuery -> Fay JQuery
onChange = ffi "%2['change'](%1)"

onSubmit :: Fay Bool -> JQuery -> Fay JQuery
onSubmit = ffi "%2['submit'](%1)"

eventX :: Event -> JQuery -> Double
eventX = ffi "%1['pageX'] - %2['get'](0)['offsetLeft']"

eventY :: Event -> JQuery -> Double
eventY = ffi "%1['pageY'] - %2['get'](0)['offsetTop']"

onDblClick :: (Event -> Fay Bool) -> JQuery -> Fay JQuery
onDblClick = ffi "%2['dblclick'](%1)"

setDraggable :: JQuery -> Fay JQuery
setDraggable = ffi "%1['draggable']()"

validate :: JQuery -> Fay () -> Fay ()
validate = ffi "%1['validate']({ \"submitHandler\": %2 })"

onLivechange :: Fay () -> JQuery -> Fay JQuery
onLivechange = ffi "%2['livechange'](50,%1)"

-- vim implementation shortcut
-- inoremap <F6> <ESC>:normal 0ywo<ESC>pa= ffi ""<ESC>F"i
