import System.IO 
import System.IO.Unsafe
import Control.Exception
import System.IO.Error 
import System.Process
import Control.Monad (when)
import Text.Printf
import System.IO.Unsafe

-------- MODELS --------
import Models.Vacina
import Models.Paciente

import System.Directory
import System.IO

main:: IO()
main = do
    dataVacina <- openFile "../Data/Vacina.txt" ReadMode
    vacina <- lines <$> hGetContents dataVacina
    print vacina

listaVacinasInicial :: [Vacina]
listaVacinasInicial = []

listaDatasVacinasInicial :: [String]
listaDatasVacinasInicial = []

--------------------------------CADASTRA VACINA--------------------------------

cadastraVacina :: IO ()
cadastraVacina = do
   system "clear"

   putStrLn ("Digite o ID da vacina: (Sem caracteres especiais)")
   chaveVacina <- lerEntradaString

   putStrLn ("\nDigite o nome da vacina")
   nomeVacina <- lerEntradaString 

   putStrLn ("\nDigite o prazo da vacina: (Apenas números)")
   prazoVacina <- lerEntradaString  

   putStrLn ("\nDigite a quantidade de doses da vacina: (Apenas números)")
   dosesVacina <- lerEntradaString  

   putStrLn("\nA vacina foi cadastrada com sucesso!\n")
   
   hSetBuffering stdin NoBuffering
   hSetEcho stdin False

   let vacina = Vacina chaveVacina nomeVacina prazoVacina dosesVacina

   let listaVacina = [vacina]
   let adicionarVacina = listaVacina
   escreveArquivoVacina adicionarVacina
   listaDeVacinas <- getVacinasEmLista 
   print(getVacinaByID listaDeVacinas chaveVacina)

--------------------------------CADASTRA PACIENTE-------------------------------------------

cadastraPaciente :: IO ()
cadastraPaciente = do
   system "clear"

   putStrLn ("Digite o nome do paciente: (Sem caracteres especiais)")
   nomePaciente <- lerEntradaString

   putStrLn ("\nDigite o cpf do paciente: (Apenas números)")
   cpfPaciente <- lerEntradaString 

   putStrLn ("\nDigite a data de nascimento do paciente: (Apenas números)")
   dataNascimento <- lerEntradaString  

   putStrLn("\nO paciente foi cadastrado com sucesso!\n")
   
   hSetBuffering stdin NoBuffering
   hSetEcho stdin False

   let paciente = Paciente nomePaciente cpfPaciente dataNascimento listaDatasVacinasInicial listaVacinasInicial

   let listaPaciente = [paciente]
   let adicionarPaciente = listaPaciente
   escreveArquivoPaciente adicionarPaciente
   
   --action <- getKey
   --telaInicial 0

------------------------------------CADASTRA VACINA AO PACIENTE-------------------------------

cadastraVacinaAoPaciente :: IO ()
cadastraVacinaAoPaciente = do
   system "clear"

   putStrLn ("ID")
   idVacina <- lerEntradaString

   putStrLn ("\nCPF")
   cpfPaciente <- lerEntradaString

   putStrLn ("\nData")
   dataVacinacao <- lerEntradaString 


   hSetBuffering stdin NoBuffering
   hSetEcho stdin False

   listPacientes <- getPacientesEmLista

   listaDeVacinas <- getVacinasEmLista 

   let testePacientes = listPacientes
   
   let vacina = getVacinaByID listaDeVacinas idVacina
   
   let resultado = adicionaVacina listPacientes cpfPaciente dataVacinacao vacina
   
   testePacientes <- getPacientesEmLista
   print(testePacientes)
   



lerEntradaString :: IO String
lerEntradaString = do
         hSetBuffering stdin LineBuffering
         hSetEcho stdin True
         x <- getLine
         return x

lerEntradaInt :: IO Int
lerEntradaInt = do
         hSetBuffering stdin LineBuffering
         hSetEcho stdin True
         x <- readLn
         return x

lerEntradaDouble :: IO Double
lerEntradaDouble = do
         hSetBuffering stdin LineBuffering
         hSetEcho stdin True
         x <- readLn
         return x









---------------------------------------------------------------
---------------------------------------------------------------

