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

Supported API calls
-------------------

This binding is a work in progress. I'm adding calls by section of the jQuery
docs. There is some overlap in the sections, but the following sections are
(mostly) complete.

- Attributes
- Core
- CSS
- Traversing

Still to do
-----------

- Ajax
- Data
- Deferred Object
- Effects
- Events
- Forms
- Internals
- Manipulation
- Miscellaneous
- Offset
- Plugins
- Properties
- Selectors
- Utilities
