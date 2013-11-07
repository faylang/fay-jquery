Fay jQuery
==========

jQuery bindings for Fay. This project is experimental, but seems to work pretty well!

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


Changelog
=========

### 0.5 (2013-11-07)

* Add `Selectable` typeclass (with instances for `Text`, `JQuery` and `Element`. `String` is not a valid instance.)
* `select` and `is` now accept `Selectable a => a` as the first argument.
* `selectElement`, `selectObject`, `isJQuery`, and `isElement` has been removed in favor of `select` and `is`.
* `createJQuery :: Text -> a -> Fay JQuery` has been replaced by `selectInContext :: (Selectable a, Selectable b) => a -> b -> Fay JQuery`
* `isWith :: (Double -> Bool) -> JQuery -> Fay JQuery` has changed to `isWith :: (Int -> Bool) -> JQuery -> Fay JQuery`
* Updated usage instructions in README

Bug fixes:
* `is` now returns Bool
