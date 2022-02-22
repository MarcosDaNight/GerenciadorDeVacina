module CartaoDeVacina(
    CartaoDeVacina(CartaoDeVacina),
    escreveArquivoCartaoDeVacina,
    getPaciente,
    getAplicador,
    getDataDeAplicao,
    escreveDoseAplicada,
    escreveAplicador,
    escrevePaciente,
    escreveVacina
) where

import Paciente(getPacientePeloId, getPacienteId, fromIO)
import Aplicador(getAplicadorPeloId, getAplicadorId, fromIO)
import Vacina(getVacinaPeloId, getVacinaId, fromIO)

import System.IO
import Util
import System.IO.Unsafe


data CartaoDeVacina = CartaoDeVacina{
    id :: Int,
    paciente :: Int,
    aplicador :: Int,
    vacina :: Int,
    dataDeAplicao :: [Date]
} deriving (Show, Read)


------------------------------ Getters ------------------------------


getAtributoCartaoDeVacina :: CartaoDeVacina -> String
getAtributoCartaoDeVacina (CartaoDeVacina {Id = i, pacienteId = p, aplicadorId = a, vacinaId = v, dataDeAplicao = [d]}) = i++","++p ++","++a++","++v","++d 

-- pensar em lógica de acessar vacina através do id salvo no cartão
getDosesDeVacinas :: String -> [Vacina]
getDosesDeVacinas Vacina {vacinas = v} = v



------------------------------ Gera_Cartao ------------------------------

mapeiaIdCartao :: [Cartao] -> [(String, Cartao)]
mapeiaIdCartao [] = []
mapeiaIdCartao (id:ids) = (getCartaoId i, i) : mapeiaIdCartao cs

adicionaDose :: [Paciente] -> String -> Vacina -> Maybe [Paciente]
adicionaDose [] idPaciente novaDose = Nothing
adicionaDose (Paciente {nomePaciente = n, idPaciente = id, dataDeAplicao = d, vacina = v}:cs) idPaciente novaDose
    | id == idPaciente = Just ([Paciente n id d ([novaDose])] ++cs)
    | otherwise = adicionaDose cs idPaciente novaDose

getDosesTomadasToString :: [String] -> String
getDosesTomadasToString [] = []
getDosesTomadasToString (d:ds) = if lenght ds > 0 then d ++ "," ++ getVacinaIdToString ds else d ++ "\n" 


------------------------------ IO_Cartao ------------------------------


------------------------------ UTIL ------------------------------



---------------------------------------------------------------------------------------


