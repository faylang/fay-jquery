## Changelog

#### 0.6.0.2 (2014-01-06)

* Bug fix: Force thunks on polymorphic arguments such as `a` in `append :: Selectable a => a -> JQuery -> Fay JQuery`. Previously only constant values would be passed to jQuery correctly for these arguments.

#### 0.6.0.1 (2013-12-28)

* Fix typo in constraint, fixes build

### 0.6 (2013-12-26)

* Constrain more free type variables to `Selectable`
* Change `getAttr :: Text -> JQuery -> Fay Text` to `Text -> JQuery -> Fay (Defined Text)`

### 0.5 (2013-11-07)

* Add `Selectable` typeclass (with instances for `Text`, `JQuery` and `Element`. `String` is not a valid instance.)
* `select` and `is` now accept `Selectable a => a` as the first argument.
* `selectElement`, `selectObject`, `isJQuery`, and `isElement` has been removed in favor of `select` and `is`.
* `createJQuery :: Text -> a -> Fay JQuery` has been replaced by `selectInContext :: (Selectable a, Selectable b) => a -> b -> Fay JQuery`
* `isWith :: (Double -> Bool) -> JQuery -> Fay JQuery` has changed to `isWith :: (Int -> Bool) -> JQuery -> Fay JQuery`
* Updated usage instructions in README

Bug fixes:
* `is` now returns `Bool`

### 0.4.0.1 (2013-09-24)

* Fixed bug in definition of `clone`
* Don't define `fromIntegral`.

### 0.4 (2013-08-27)

* Updated to use fay-text, which fixes bugs in ajax FFI calls.
