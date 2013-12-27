Fay jQuery
==========

[Changelog](CHANGELOG.md)

jQuery bindings for Fay. This project is experimental, but seems to work pretty well!

The short-term goals of this project are to help discover the real world
requirements of Fay and to invite bikeshedding over the fay-jquery API. That
means that names and types may change in rapid and annoying ways until
conventions settle down.

The one consistent convention in the library is that the jQuery object on which
methods operate is the *last* parameter to every function. This allows simple
monadic composition:

```haskell
{-# LANGUAGE RebindableSyntax, OverloadedStrings #-}

import Fay.Text (fromString)
import JQuery
import Prelude

(>=>) :: (a -> Fay b) -> (b -> Fay c) -> a -> Fay c
f >=> g = \x -> f x >>= g

makeSquare :: JQuery -> Fay JQuery
makeSquare = addClass "square" >=>
             setWidth 400 >=>
             setHeight 400

-- `ready` is the same as jQuery(document).ready(%1);
-- You generally need to wait for this event to fire before modifying the DOM.
main :: Fay ()
main = ready $ do
    select "#elementToMakeSquare" >>= makeSquare
    return ()
```

Usage
-----


Install:
```bash
cabal install fay-text fay-jquery
```

Compile your file:

```bash
fay --package fay-jquery,fay-text MyFile.hs
```


Supported API calls
-------------------

This binding is a work in progress. We're adding calls by section of the jQuery
docs. There is some overlap in the sections, but the following sections are
(mostly) complete.

- Ajax
- Attributes
- Core
- CSS
- Effects (Basic, Fading)
- Manipulation
- Traversing
- Events

Still to do
-----------

- Data
- Deferred Object
- Effects (Custom, Sliding)
- Forms
- Internals
- Miscellaneous
- Offset
- Plugins
- Properties
- Utilities

Not Applicable
--------------

- Selectors
