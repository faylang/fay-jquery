{-# LANGUAGE NoImplicitPrelude #-}

module Test (main) where

import Prelude
import JQuery
import FFI

(>=>)       :: (a -> Fay b) -> (b -> Fay c) -> (a -> Fay c)
f >=> g     = \x -> f x >>= g

myMapM            :: (a -> Fay b) -> [a] -> Fay [b]
myMapM f as       =  mySequence (map f as)

mySequence    :: [Fay a] -> Fay [a]
mySequence ms = let k m m' = do { x <- m; xs <- m'; return (x:xs) } in
                foldr k (return []) ms

tableData = [ ["S", "Soprano"]
            , ["A", "Alto"]
            , ["T", "Tenor"]
            , ["B", "Bass"]
            ]

buildCell :: String -> Fay JQuery
buildCell cellData = do
    cell <- select "<td/>"
    setText cellData cell

buildRow :: [String] -> Fay JQuery
buildRow rowData = do
    row <- select "<tr/>"
    myMapM (buildCell >=> appendToJQuery row) rowData
    return row

buildTable :: [[String]] -> Fay JQuery
buildTable rowsData = do
    table <- select "<table/>"
    myMapM (buildRow >=> appendToJQuery table) rowsData
    return table

dir :: a -> Fay JQuery
dir = ffi "console.dir(%1)"

clog :: String -> Fay JQuery
clog = ffi "console.log(%1)"

main :: Fay ()
main = ready $ do
    div <- select "#replacementDiv"
    table <- buildTable tableData
    replaceWithJQuery table div
    addZebraStriping table

    testAnimations
    testAjax

    return ()

testAnimations :: Fay ()
testAnimations = do
  body <- select "body"
  container <- select "<div/>" >>= appendTo body
  thing <- select "<div>Hello</div>" >>= appendTo container
  select "<input type='button' value='Hide slow'>" >>= click (const $ hide Slow thing >> return ()) >>= appendTo container
  select "<input type='button' value='Show instantly'>" >>= click (const $ jshow Instantly thing >> return ()) >>= appendTo container
  select "<input type='button' value='Toggle 100'>" >>= click (const $ toggle (Speed 100) thing >> return ()) >>= appendTo container
  select "<input type='button' value='Chained'>" >>= click (const $ runAnimation $ chainedAnimation thing) >>= appendTo container
  return ()

    where
      empty = const $ return ()
      chainedAnimation el = chainAnims [speed Fast (anim Toggle el), speed Slow (anim Toggle el), anim FadeOut el, anim FadeIn el]

data AjaxTest = AjaxTest Double Double

testAjax :: Fay ()
testAjax = do
  ajax "http://www.example.com" putStrLn (\_ _ _ -> return ())
  ajaxPost "http://www.example.com" (AjaxTest 1 2) putStrLn (\_ _ _ -> return ())
  ajaxPostParam "http://www.example.com" "foo" (AjaxTest 1 2) putStrLn (\_ _ _ -> return ())


isDivisibleBy :: Double -> Double -> Bool
--isDivisibleBy num divisor = let divided = num/divisor in divided - (fromIntegral $ floor divided) == 0
--isDivisibleBy num divisor = (div (floor num) (floor divisor)) * (floor divisor) == (floor num)
isDivisibleBy num divisor = if num == 0 then True
                            else if num < 0 then False
                            else isDivisibleBy (num - divisor) divisor

zebraStripeRows :: Double -> String -> Fay String
zebraStripeRows index _ = return $ if isDivisibleBy index 2 then "odd" else "even"

addZebraStriping :: JQuery -> Fay JQuery
addZebraStriping table = do
    --addClassWith zebraStripeRows rows
    evenRows <- findSelector "tr:even" table
    addClass "even" evenRows
    oddRows <- findSelector "tr:odd" table
    addClass "odd" oddRows

{--
manipulateP :: JQuery -> Fay JQuery
manipulateP = setText "It's been replaced!" >=>
              --setStyle "background-color" "red" >=>
              addClass "asdf" >=>
              addClassWith addTableRowClasses
--}
