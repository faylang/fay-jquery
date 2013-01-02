Fay jQuery
==========

jQuery bindings for Fay. This project is experimental and not suitable for
production purposes.

The short-term goals of this project are to help discover the real world
requirements of Fay and to invite bikeshedding over the fay-jquery API. That
means that names and types may change in rapid and annoying ways until
conventions settle down.

The one consistent convention in the library is that the jQuery object on which
methods operate is the *last* parameter to every function. This allows simple
monadic composition:

```haskell
makeSquare :: JQuery -> Fay JQuery
makeSquare = addClass "square" >=>
             setWidth 400 >=>
             setHeight 400

main :: Fay ()
main = do
    makeSquare $ select "#elementToMakeSquare"
    return ()
```

Usage
-----

To use this with fay, cabal install the package which will put the
source files in fay ~/.cabal/share/fay-jquery-0.1.0.0/src. You can then
compile with fay using

```
fay --include=~/.cabal/share/fay-jquery-0.1.0.0/src MyFile.hs
```

Supported API calls
-------------------

This binding is a work in progress. I'm adding calls by section of the jQuery
docs. There is some overlap in the sections, but the following sections are
(mostly) complete.

- Ajax
- Attributes
- Core
- CSS
- Effects (Basic, Fading)
- Manipulation
- Traversing

Still to do
-----------

- Data
- Deferred Object
- Effects (Custom, Sliding)
- Events
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
