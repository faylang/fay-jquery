module Test (main) where

import Language.Fay.Prelude hiding (return, ($), (.), (>>=), (++), map, foldr, find)
import Language.Fay.JQuery
import Language.Fay.FFI

(>=>)       :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g     = \x -> f x >>= g

myMapM            :: Monad m => (a -> m b) -> [a] -> m [b]
myMapM f as       =  mySequence (map f as)

mySequence    :: Monad m => [m a] -> m [a]
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

dir :: (Foreign a) => a -> Fay JQuery
dir = ffi "console.dir(%1)"

clog :: String -> Fay JQuery
clog = ffi "console.log(%1)"

main :: Fay ()
main = ready $ do
    div <- select "#replacementDiv"
    table <- buildTable tableData
    replaceWithJQuery table div
    addZebraStriping table
    return ()

isDivisibleBy :: Double -> Double -> Bool
--isDivisibleBy num divisor = let divided = num/divisor in divided - (fromIntegral $ floor divided) == 0
--isDivisibleBy num divisor = (div (floor num) (floor divisor)) * (floor divisor) == (floor num)
isDivisibleBy num divisor = if num == 0 then True
                            else if num < 0 then False
                            else isDivisibleBy (num - divisor) divisor

zebraStripeRows :: Double -> String -> Fay String
zebraStripeRows index _ = return $ if isDivisibleBy index 2 then "odd" else "even"

addZebraStriping = JQuery -> Fay JQuery
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
