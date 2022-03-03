module Models.Paciente where

import System.IO
import System.IO.Unsafe

data Paciente = Paciente{
  nomePaciente :: String,
  cpf :: String,
  data_nascimento :: String,
  data_vacinacao :: [String],
  chave_vacina :: [Int]
} deriving (Show, Read)

data Pacientes = Pacientes{
  pacientes :: [(String, Paciente)]
} deriving (Show, Read)

------------------------------ Getters ------------------------------
getAtributosPaciente :: Paciente -> String
getAtributosPaciente (Paciente {nomePaciente = nome, cpf = id, data_nascimento = nascimento}) = nome++","++id++","++nascimento

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
adicionaVacina :: [Paciente] -> String -> String -> Int -> Maybe [Paciente]
adicionaVacina [] cpfPaciente dataVacinacao keyVacina = Nothing 
adicionaVacina (Paciente {nomePaciente = n, cpf = c, data_nascimento = d, data_vacinacao = dv, chave_vacina = k}:cs) cpfPaciente dataVacinacao keyVacina
  | c == cpfPaciente = Just ([Paciente n c d (dv++[dataVacinacao]) (k++[keyVacina])] ++ cs)
  | otherwise = adicionaVacina cs cpfPaciente dataVacinacao keyVacina

------------------------------ IOPaciente------------------------------
escreveArquivoPaciente:: [Paciente] -> IO ()
escreveArquivoPaciente pacientes = do
    arq <- openFile "../Data/Paciente.txt" AppendMode 
    hPutStr arq(formataParaEscritaPacientes pacientes)
    hClose arq












-- Leitura

getPacientesEmLista :: IO [Paciente]
getPacientesEmLista = do
    listaPacienteStr <- lerPaciente
    let pacientes = (converteEmListaPaciente listaPacienteStr)
    return pacientes

converteEmListaPaciente :: [String] -> [Paciente]
converteEmListaPaciente [] =[]
converteEmListaPaciente (atributo:lista) =
    converteEmPaciente (split atributo ',') : converteEmListaPaciente lista


converteEmPaciente :: [String] -> Paciente
converteEmPaciente paciente = Paciente nomePaciente cpf data_nascimento data_vacinacao chave_vacina
    where
        nomePaciente = paciente !! 0
        cpf = paciente !! 1
        data_nascimento = paciente !! 2
        data_vacinacao = []
        chave_vacina = []

lerPaciente :: IO[String]
lerPaciente = do
    arq <- openFile "../../Data/Paciente.txt" ReadMode 
    conteudo <- lines <$> hGetContents arq
    return conteudo



------------------- UTIL -------------------

formataParaEscritaPacientes :: [Paciente] -> String
formataParaEscritaPacientes [] = []
formataParaEscritaPacientes (c:cs) = getAtributosPaciente c ++ "\n" ++ formataParaEscritaPacientes cs

quebraPaciente :: String -> [String]
quebraPaciente entrada = split entrada ','

split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split cs delim

pacienteToString :: [String] -> String
pacienteToString lista = "Nome:" ++ (lista !! 0) ++ " | cpf:" ++ (lista !! 1) ++ " | data de cadastro:" ++ (lista !! 2)

