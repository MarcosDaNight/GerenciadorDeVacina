module Paciente (
  Paciente(Paciente),
  Pacientes(Pacientes),
  atualizaArquivoPaciente,
  getPacientes,
) where

import System.IO
import System.IO.Unsafe

data Paciente = Paciente{
  nomePaciente :: String,
  cpf :: String,
  data_nascimento :: String,
  data_vacinacao :: String
} deriving (Show, Read)

data Pacientes = Pacientes{
  pacientes :: [(String, Paciente)]
} deriving Show

getAtributosPaciente :: Paciente -> String
getAtributosPaciente (Paciente {nomePaciente = nome, cpf = id, data_nascimento = nascimento, data_vacinacao = vacinacao}) = nome++","++id++","++nascimento++","++vacinacao

getPacientes :: Pacientes -> [Paciente]
getPacientes (Pacientes {pacientes = p}) = getPacientesData p

getPacientesData :: [(String, Paciente)] -> [Paciente]
getPacientesData [] = []
getPacientesData ((_,d): t) = d : getPacientesData t

getCpf :: Paciente -> String
getCpf Paciente {cpf = id} = id

---- Adiciona Paciente ----
mapeiaCpf :: [Paciente] -> [(String, Paciente)]
mapeiaCpf [] = []
mapeiaCpf (c:cs) = (getCpf c, c) : mapeiaCpf cs

adicionaVacina :: [Paciente] -> String -> String -> Maybe [Paciente]
adicionaVacina [] cpfPaciente dataVacinacao = Nothing
adicionaVacina (Paciente {nomePaciente = n, cpf = c, data_nascimento = d, data_vacinacao = v}:cs) cpfPaciente dataVacinacao
  | c == cpfPaciente = Just ([Paciente n c d ++ cs])
  | otherwise = adicionaVacina cs cpfPaciente dataVacinacao

-- Lidar com CSV
atualizaArquivoPaciente :: [Paciente] -> IO ()
atualizaArquivoPaciente paciente = do
  arq <- openFile "../Data/Paciente.csv" AppendMode
  hPutStr arq (formataParaEscritaPacientes paciente)
  hClose arq

-- Ver métodos de iteração

-- Leitura

getListaPacientes :: IO [Paciente]
getListaPacientes = do
  listaPacientes <- lerPacientes
  let pacientes = (converteEmListaPaciente listaPacientes)
  return pacientes

converteEmListaPaciente :: [String] -> [Paciente]
converteEmListaPaciente [] = []
converteEmListaPaciente (paciente:lista) =
  converteEmPaciente (split paciente ',') : converteEmListaPaciente lista

converteEmPaciente :: [String] -> Paciente
converteEmPaciente paciente = Paciente nome cpf dataNascimento dataVacinacao
  where 
    nome = head paciente
    cpf = paciente !! 1
    dataNascimento = paciente !! 2
    dataVacinacao = paciente !! 3

lerPacientes :: IO[String]
lerPacientes = do
  arq <- openFile "../Data/Paciente.csv" ReadMode
  resultado <- lines <$> hGetContents arq
  return resultado



-- UTIL 

formataParaEscritaPacientes :: [Paciente] -> String
formataParaEscritaPacientes [] = []
formataParaEscritaPacientes (c:cs) = getAtributosPaciente c ++ "\n" ++ formataParaEscritaPacientes cs

quebraPaciente :: String -> [String]
quebraPaciente entrada = split entrada ','

pacienteToString :: [String] -> String
pacienteToString lista = "Nome:" ++ (lista !! 0) ++ " | cpf:" ++ (lista !! 1) ++ " | data de cadastro:" ++ (lista !! 2)



