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



------------------------------ Gera_Cartao ------------------------------


------------------------------ IO_Cartao ------------------------------


------------------------------ UTIL ------------------------------



---------------------------------------------------------------------------------------


