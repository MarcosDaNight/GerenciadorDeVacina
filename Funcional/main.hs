import Models.Vacina

main:: IO()
main = do
    vacina <- getLine
    let pfizer = read vacina :: Vacina
    putStrLn $ show pfizer
    putStrLn $ show $ nome pfizer
    putStrLn $ show $ prazo pfizer
    putStrLn $ show $ doses pfizer

