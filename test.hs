{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

-- Compile with: fay --package fay-text,fay-jquery test.hs --pretty

module Test (main) where

import Fay.Text (Text, fromString)
import JQuery
import Prelude hiding (div)
import qualified Fay.Text as T

myMapM            :: (a -> Fay b) -> [a] -> Fay [b]
myMapM f as       =  mySequence (map f as)

mySequence    :: [Fay a] -> Fay [a]
mySequence ms = let k m m' = do { x <- m; xs <- m'; return (x:xs) } in
                foldr k (return []) ms

tableData :: [[Text]]
tableData = [ ["S", "Soprano"]
            , ["A", "Alto"]
            , ["T", "Tenor"]
            , ["B", "Bass"]
            ]

buildCell :: Text -> Fay JQuery
buildCell cellData = do
    cell <- select "<td/>"
    setText cellData cell

buildRow :: [Text] -> Fay JQuery
buildRow rowData = do
    row <- select "<tr/>"
    myMapM (buildCell >=> appendToJQuery row) rowData
    return row

buildTable :: [[Text]] -> Fay JQuery
buildTable rowsData = do
    table <- select "<table/>"
    myMapM (buildRow >=> appendToJQuery table) rowsData
    return table

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
  select ("<div>" `T.append` "Thunk" `T.append` "</div>") >>= appendTo body
  return ()

    where
      chainedAnimation el = chainAnims [speed Fast (anim Toggle el), speed Slow (anim Toggle el), anim FadeOut el, anim FadeIn el]

data AjaxTest = AjaxTest Double Double

testAjax :: Fay ()
testAjax = do
  ajax "http://www.example.com" putStrLn (\_ _ _ -> return ())
  ajaxPost "http://www.example.com" (AjaxTest 1 2) putStrLn (\_ _ _ -> return ())
  ajaxPostParam "http://www.example.com" "foo" (AjaxTest 1 2) putStrLn (\_ _ _ -> return ())

addZebraStriping :: JQuery -> Fay JQuery
addZebraStriping table = do
    evenRows <- findSelector "tr:even" table
    addClass "even" evenRows
    oddRows <- findSelector "tr:odd" table
    addClass "odd" oddRows
