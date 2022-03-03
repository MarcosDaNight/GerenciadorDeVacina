{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Voluntario (
    Voluntario(Voluntario),
    Voluntarios(Voluntarios),
    escreverArquivoVoluntario,
    getVoluntarioEmLista,

) where

import System.IO
import System.IO.Unsafe

data Voluntario = Voluntario{
    nomeVoluntario :: String,
    cpf :: String,
    data_cadastro :: String
} deriving (Show, Read)

data Voluntarios = Voluntarios{
    voluntarios :: [(String, Voluntario)]
} deriving Show





getAtributosVoluntario :: Voluntario -> String
getAtributosVoluntario (Voluntario {nomeVoluntario = nome, cpf = id, data_cadastro = dataDeCadastro}) = nome++","++id++","++dataDeCadastro

getVoluntarios :: Voluntarios -> [Voluntario]
getVoluntarios (Voluntarios {voluntarios = c}) = getVoluntariosFromTuple c

getVoluntariosFromTuple :: [(String, Voluntario)] -> [Voluntario]
getVoluntariosFromTuple [] = []
getVoluntariosFromTuple ((_,c): cs) = c : getVoluntariosFromTuple cs

getCpf :: Voluntario -> String
getCpf Voluntario {cpf = c} = c


----------------------CADASTRAVOLUNTARIO----------------------------







----------------------IOVOLUNTARIO----------------------------

escreverArquivoVoluntario :: [Voluntario] -> IO ()
escreverArquivoVoluntario voluntarios = do
    arq <- openFile "../arquivos/Voluntarios.csv" AppendMode
    arqVoluntarios <- openFile "../arquivos/Voluntarios.csv" AppendMode
    let dataVoluntario = getVoluntariosToCsv voluntarios
    hPutStr arq (formataParaEscritaVoluntarios voluntarios)
    hPutStr arqVoluntarios dataVoluntario
    hClose arq
    hClose arqVoluntarios


-------------------------VISUALIZACAO---------------------------


getVoluntarioEmLista :: IO [Voluntario]
getVoluntarioEmLista = do
    listaVoluntarioStr <- lerVoluntarios
    let voluntarios = (converteEmListaVoluntario listaVoluntarioStr)
    return voluntarios


lerVoluntarios :: IO[String]
lerVoluntarios = do
    arq <- openFile "../arquivos/Voluntarios.csv" ReadMode
    conteudo <- lines <$> hGetContents arq
    return conteudo

---------------------------UTIL------------------------------

formataParaEscritaVoluntarios :: [Voluntario] -> String
formataParaEscritaVoluntarios [] = []
formataParaEscritaVoluntarios (c:cs) = getAtributosVoluntario c ++ "\n" ++ formataParaEscritaVoluntarios cs

quebraVoluntario :: String -> [String]
quebraVoluntario entrada = split entrada ','

formataExibicaoVoluntario :: [String] -> String
formataExibicaoVoluntario lista = "Nome: " ++ (lista !! 0) ++ " | cpf:" ++ (lista !! 1) ++ " | data de cadastro:" ++ (lista !! 2)


-- O que usar para substituir produto?
