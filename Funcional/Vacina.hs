module Vacina(
    Vacina(Vacina),
    escreveArquivoVacina,
    getPaciente,
    escreveVacina,
    escrevePrazo,
    escreveQtnDoses,
    escrevePaciente
) where

import Paciente(getPacientePeloId, getPacienteId, fromIO)

import System.IO
import Util
import System.IO.Unsafe

-- id, vacina, doses, prazo
data Vacina = Vacina{
    id :: Int,
    nome :: String,
    prazo :: Int,
    doses :: Int,
} deriving (Show, Read)

------------------------------ Getters ------------------------------

getAtributoVacina :: Vacina -> String
getAtributoVacina (Vacina {id = i, nome = n, prazo = p, doses = d}) = i++", "++n++", "++p", "++d++

