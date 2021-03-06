{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use :" #-}
module Models.Paciente where

import System.IO
import System.IO.Unsafe
import Models.Vacina
import Control.Exception (evaluate)

data Paciente = Paciente{
  cpf :: String,
  nomePaciente :: String,
  data_nascimento :: String,
  data_vacinacao :: String,
  vacinas :: String
} deriving (Show, Read)

------------------------------ Getters --------------------------------
getAtributosPaciente :: Paciente -> String
getAtributosPaciente (Paciente {cpf = id, nomePaciente = nome, data_nascimento = nascimento, data_vacinacao = vacinacao, vacinas = dose}) = id++","++nome++","++nascimento++","++ vacinacao++","++dose

getPacientesEmLista :: IO [Paciente]
getPacientesEmLista = do
    listaPacienteStr <- lerPaciente
    let pacientes = (converteEmListaPaciente listaPacienteStr)
    return pacientes

------------------------------ AdicionaVacinaAoPaciente ----------------
adicionaVacina :: [Paciente] -> String -> String -> String -> [Paciente]
adicionaVacina [] cpfPaciente dataVacinacao vacinaAplicada = []
adicionaVacina (Paciente { cpf = c, nomePaciente = n, data_nascimento = d, data_vacinacao = dv, vacinas = v}:cs) cpfPaciente dataVacinacao vacinaAplicada
  | c == cpfPaciente = [Paciente c n d dataVacinacao vacinaAplicada]
  | otherwise = adicionaVacina cs cpfPaciente dataVacinacao vacinaAplicada

------------------------------ IOPaciente ------------------------------
escreveArquivoPaciente:: [Paciente] -> IO ()
escreveArquivoPaciente pacientes = do
    arq <- openFile "../Data/Paciente.txt" AppendMode  
    hPutStr arq(formataParaEscritaPacientes pacientes)
    hFlush arq
    hClose arq

------------------- UTIL -------------------
formataParaEscritaPacientes :: [Paciente] -> String
formataParaEscritaPacientes [] = []
formataParaEscritaPacientes (c:cs) = getAtributosPaciente c ++ "\n" ++ formataParaEscritaPacientes cs

formataParaEscritaPaciente :: Paciente -> String
formataParaEscritaPaciente Paciente {cpf = c, nomePaciente = n, data_nascimento = d, data_vacinacao = dv, vacinas = v} = c++","++n++","++d++","++dv++","++v

pacienteToString :: [String] -> String
pacienteToString lista = "Nome:" ++ (lista !! 1) ++ " | cpf:" ++ (lista !! 0) ++ " | data de cadastro:" ++ (lista !! 2)

quebraString:: [Char] -> [String]
quebraString palavra = split palavra ','

pegaIdVacinaPaciente:: [String] -> String
pegaIdVacinaPaciente [] = ""
pegaIdVacinaPaciente (x:xs) = last(quebraString(x)) ++ pegaIdVacinaPaciente xs

formataPaciente :: [String] -> String
formataPaciente [] = ""
formataPaciente (c:cs) = "Nome: " ++ (t !! 1) ++ " | CPF: " ++ (t !! 0) ++ " | Vacina Tomada: " ++ nomeVacina ++ "\n" ++ formataPaciente cs
   where
      t = quebraString c
      nomeVacina = get1st (getVacinaNome (t !! 4))

get1st:: [String] -> String
get1st [] = ""
get1st (x:xs) = x

isolaCpf:: [Char] -> String
isolaCpf paciente = head(split paciente ',' )

removeLetra:: Char -> [Char] -> String
removeLetra _ []                 = []
removeLetra x (y:ys) | x /= y || y == ' ' = removeLetra x ys
                     | otherwise = y : removeLetra x ys

removeItem :: String -> [String] -> [String]
removeItem _ []                 = []
removeItem x (y:ys) | x /= isolaCpf y    = removeItem x ys
                    | otherwise = y : removeItem x ys

converteEmListaPaciente :: [String] -> [Paciente]
converteEmListaPaciente [] = []
converteEmListaPaciente (atributo:lista) =
    converteEmPaciente (split atributo ',') : converteEmListaPaciente lista

converteEmPaciente :: [String] -> Paciente
converteEmPaciente paciente = Paciente cpf nomePaciente data_nascimento data_vacinacao vacina
    where
        cpf = paciente !! 0
        nomePaciente = paciente !! 1
        data_nascimento = paciente !! 2
        data_vacinacao = paciente !! 3
        vacina = paciente !! 4

lerPaciente :: IO[String]
lerPaciente = do
    arq <- openFile "../Data/Paciente.txt" ReadMode 
    conteudo <- lines <$> hGetContents arq
    evaluate(length conteudo)
    return conteudo