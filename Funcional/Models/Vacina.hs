module Models.Vacina where

    --import Paciente(getPacientePeloId, getPacienteId, fromIO)

    import System.IO
    import System.IO.Unsafe

-- id, vacina, doses, prazo

    data Vacina = Vacina{
        id :: Int,
        nome :: String,
        prazo :: Int,
        doses :: Int
    }  deriving (Show, Read)

------------------------------ Getters ------------------------------


