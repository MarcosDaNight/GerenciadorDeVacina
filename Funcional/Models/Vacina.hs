module Models.Vacina where

    --import Paciente(getPacientePeloId, getPacienteId, fromIO)

    import System.IO
    import System.IO.Unsafe

-- id, vacina, doses, prazo

    data Vacina = Vacina{
        key :: String,
        nome :: String,
        prazo :: String,
        doses :: String
    }  deriving (Show, Read)

------------------------------ Getters ------------------------------
    getAtributosVacina :: Vacina -> String 
    getAtributosVacina (Vacina {key = k, nome = n, prazo = p, doses = d}) = k++","++n++","++p++","++d


------------------------------ IOVacina ------------------------------
    escreveArquivoVacina :: [Vacina] -> IO ()
    escreveArquivoVacina vacinas = do
        arq <- openFile "../../Data/Vacina.txt" AppendMode 
        hPutStr arq(formataParaEscritaVacina vacinas)
        hClose arq

------------------------------ Vizualização ------------------------------
    getVacinasEmLista :: IO [Vacina]
    getVacinasEmLista = do
        listaVacinaStr <- lerVacina
        let vacinas = (converteEmListaVacina listaVacinaStr)
        return vacinas

    converteEmListaVacina :: [String] -> [Vacina]
    converteEmListaVacina [] =[]
    converteEmListaVacina (atributo:lista) =
        converteEmVacina (split atributo ',') : converteEmListaVacina lista


    converteEmVacina :: [String] -> Vacina
    converteEmVacina vacina = Vacina key nome prazo doses
        where
            key = vacina !! 0
            nome = vacina !! 1
            prazo = vacina !! 2
            doses = vacina !! 3

    lerVacina :: IO[String]
    lerVacina = do
        arq <- openFile "../../Data/Vacina.txt" ReadMode 
        conteudo <- lines <$> hGetContents arq
        return conteudo


------------------------------ UTIL ------------------------------

    formataParaEscritaVacina :: [Vacina] -> String 
    formataParaEscritaVacina [] = []
    formataParaEscritaVacina (v:vs) = getAtributosVacina v ++ "\n" ++ formataParaEscritaVacina vs