{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use :" #-}
module Models.Paciente where

import System.IO
import System.IO.Unsafe
import Models.Vacina

data Paciente = Paciente{
  nomePaciente :: String,
  cpf :: String,
  data_nascimento :: String,
  data_vacinacao :: [String],
  vacinas :: [String]
} deriving (Show, Read)

data Pacientes = Pacientes{
  pacientes :: [(String, Paciente)]
} deriving (Show, Read)

------------------------------ Getters ------------------------------
getAtributosPaciente :: Paciente -> String
getAtributosPaciente (Paciente {nomePaciente = nome, cpf = id, data_nascimento = nascimento, data_vacinacao = vacinacao, vacinas = doses}) = nome++","++id++","++nascimento++","++converteListaDatasEmString vacinacao++","++converteListaDatasEmString doses



converteListaDatasEmString :: [String] -> String 
converteListaDatasEmString [] = ""
converteListaDatasEmString (c:cs) = c ++ "," ++ converteListaDatasEmString cs

getPacientes :: Pacientes -> [Paciente]
getPacientes (Pacientes {pacientes = p}) = getPacientesData p

getPacientesData :: [(String, Paciente)] -> [Paciente]
getPacientesData [] = []
getPacientesData ((_,d): t) = d : getPacientesData t

getCpf :: Paciente -> String
getCpf Paciente {cpf = id} = id

------------------------------ MapeiaCPF ------------------------------
mapeiaCpf :: [Paciente] -> [(String, Paciente)]
mapeiaCpf [] = []
mapeiaCpf (c:cs) = (getCpf c, c) : mapeiaCpf cs

------------------------------ AdicionaVacinaAoPaciente ------------------------------
adicionaVacina :: [Paciente] -> String -> String -> String -> [Paciente]
adicionaVacina [] cpfPaciente dataVacinacao vacinaAplicada = []
adicionaVacina (Paciente {nomePaciente = n, cpf = c, data_nascimento = d, data_vacinacao = dv, vacinas = v}:cs) cpfPaciente dataVacinacao vacinaAplicada
  | c == cpfPaciente = [Paciente n c d (dv++[dataVacinacao]) (v++[vacinaAplicada])] ++ cs
  | otherwise = adicionaVacina cs cpfPaciente dataVacinacao vacinaAplicada

------------------------------ IOPaciente------------------------------
escreveArquivoPaciente:: [Paciente] -> IO ()
escreveArquivoPaciente pacientes = do
    arq <- openFile "../Data/Paciente.txt" WriteMode  
    hPutStr arq(formataParaEscritaPacientes pacientes)
    hClose arq


escreveArquivoPacienteUnico:: Paciente -> IO ()
escreveArquivoPacienteUnico paciente = do
    arq <- openFile "../Data/Paciente.txt" WriteMode  
    hPutStr arq(formataParaEscritaPaciente paciente)
    hClose arq

-- Leitura

getPacientesEmLista :: IO [Paciente]
getPacientesEmLista = do
    listaPacienteStr <- lerPaciente
    let pacientes = (converteEmListaPaciente listaPacienteStr)
    return pacientes

converteEmListaPaciente :: [String] -> [Paciente]
converteEmListaPaciente [] = []
converteEmListaPaciente (atributo:lista) =
    converteEmPaciente (split atributo ',') : converteEmListaPaciente lista


converteEmPaciente :: [String] -> Paciente
converteEmPaciente paciente = Paciente nomePaciente cpf data_nascimento data_vacinacao vacina
    where
        nomePaciente = paciente !! 0
        cpf = paciente !! 1
        data_nascimento = paciente !! 2
        data_vacinacao = []
        vacina = [paciente !! 4]

lerPaciente :: IO[String]
lerPaciente = do
    arq <- openFile "../Data/Paciente.txt" ReadMode 
    conteudo <- lines <$> hGetContents arq
    return conteudo



------------------- UTIL -------------------

formataParaEscritaPacientes :: [Paciente] -> String
formataParaEscritaPacientes [] = []
formataParaEscritaPacientes (c:cs) = getAtributosPaciente c ++ "\n" ++ formataParaEscritaPacientes cs

formataParaEscritaPaciente :: Paciente -> String
formataParaEscritaPaciente Paciente {nomePaciente = n, cpf = c, data_nascimento = d, data_vacinacao = dv, vacinas = v} = n++","++c++","++d++","++converteListaDatasEmString dv++","++converteListaDatasEmString v

pacienteToString :: [String] -> String
pacienteToString lista = "Nome:" ++ (lista !! 0) ++ " | cpf:" ++ (lista !! 1) ++ " | data de cadastro:" ++ (lista !! 2)

