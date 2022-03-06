module Models.Vacina where

--import Paciente(getPacientePeloId, getPacienteId, fromIO)

import System.IO
import System.IO.Unsafe
import Control.Exception (evaluate)
import Text.Read (Lexeme(String))
import Data.Char (digitToInt)


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

getVacinaDoses :: Char -> String
getVacinaDoses idVacina = do
    let listaVacinas = getVacinasEmLista
    let Vacina {key = k, nome = n, prazo = p, doses = d} = getVacinaByID (unsafePerformIO getVacinasEmLista) [idVacina] 
    let letra = head d
    return letra

------------------------------ IOVacina ------------------------------
escreveArquivoVacina :: [Vacina] -> IO ()
escreveArquivoVacina vacinas = do
    arq <- openFile "../Data/Vacina.txt" AppendMode 
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

getVacinaByID :: [Vacina] -> String -> Vacina
getVacinaByID [] idVacina = Vacina {key = "000", nome = "Inexistente", prazo = "00", doses = "00"}
getVacinaByID (Vacina {key = k, nome = n, prazo = p, doses = d} : cs) idVacina
  | k == idVacina = Vacina {key = k, nome = n, prazo = p, doses = d}
  | otherwise = getVacinaByID cs idVacina


converteEmVacina :: [String] -> Vacina
converteEmVacina vacina = Vacina key nome prazo doses
    where
        key = vacina !! 0
        nome = vacina !! 1
        prazo = vacina !! 2
        doses = vacina !! 3

lerVacina :: IO[String]
lerVacina = do
    arq <- openFile "../Data/Vacina.txt" ReadMode 
    conteudo <- lines <$> hGetContents arq
    evaluate(length conteudo)
    return conteudo

-- Converte IO em puro
fromIO :: IO[String] -> [String]
fromIO x = (unsafePerformIO x :: [String])

------------------------------ UTIL ------------------------------
formataParaEscritaVacina :: [Vacina] -> String 
formataParaEscritaVacina [] = []
formataParaEscritaVacina (v:vs) = getAtributosVacina v ++ "\n" ++ formataParaEscritaVacina vs

------------------- UTIL -------------------
split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split cs delim

