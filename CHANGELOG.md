## Changelog

### 0.5 (2013-11-07)

* Add `Selectable` typeclass (with instances for `Text`, `JQuery` and `Element`. `String` is not a valid instance.)
* `select` and `is` now accept `Selectable a => a` as the first argument.
* `selectElement`, `selectObject`, `isJQuery`, and `isElement` has been removed in favor of `select` and `is`.
* `createJQuery :: Text -> a -> Fay JQuery` has been replaced by `selectInContext :: (Selectable a, Selectable b) => a -> b -> Fay JQuery`
* `isWith :: (Double -> Bool) -> JQuery -> Fay JQuery` has changed to `isWith :: (Int -> Bool) -> JQuery -> Fay JQuery`
* Updated usage instructions in README

Bug fixes:
* `is` now returns `Bool`

### 0.4 (2013-08-27)

* Updated to use fay-text, which fixes bugs in ajax FFI calls.
