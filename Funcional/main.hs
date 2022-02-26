import Models.Vacina

import System.Directory
import System.IO

main:: IO()
main = do
    dataVacina <- openFile "../Data/Vacina.txt" ReadMode
    vacina <- lines <$> hGetContents dataVacina
    print vacina
    
    


