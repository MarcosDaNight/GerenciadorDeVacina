module Util where

    split :: String -> Char -> [String]
    split [] delim = [""]
    split (c:cs) delim 
        | c == delim = "" : rest
        | otherwise = (c : head rest) : tail rest
        where
            rest = split cs delim

    removeJustMaybeList :: Maybe[t] -> [t]
    removeJustMaybeList (Just a) = a

    removeJustListOfMaybe :: [Maybe t] -> [t]
    removeJustListOfMaybe [] = []
    removeJustListOfMaybe (Just x: xs) = [x] ++ removeJustListOfMaybe xs