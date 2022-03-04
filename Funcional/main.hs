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
import Text.XHtml (action)
import System.Console.Terminfo (cursorAddress)


listaVacinasInicial :: String
listaVacinasInicial = " "

listaDatasVacinasInicial :: String
listaDatasVacinasInicial = " "

--------------------------------TELA INICIAL----------------------------------
opcoesTelaInicial :: [String]
opcoesTelaInicial = ["Entrar como Paciente", "Entrar como Admin", "Sair"]

doTelaInicial :: Integer -> [Char] -> IO ()
doTelaInicial cursor action | action == "\ESC[B" = telaInicial ((cursor+1) `mod` 4)
                                                   | action == "\ESC[A" && cursor /= 0 = telaInicial (cursor-1)
                                                   | action == "\ESC[A" && cursor == 0 = telaInicial 3
                                                   | action == "\ESC[C" = mudarTelaInicial cursor
                                                   | action == "\ESC[D" = putStrLn(" \n                   Até Mais!             \n")
                                                   | otherwise = telaInicial cursor
                                                   

mudarTelaInicial :: Integer -> IO()
mudarTelaInicial cursor                          | cursor == 0 = do telaOpcoesLogin 0
                                                 | cursor == 1 = do telaOpcaoCadastro 0            
                                                 | cursor == 2 = do telaOpcoesLogin 0
                                                 | otherwise = telaInicial 0



telaInicial :: Integer -> IO ()
telaInicial cursor = do

   system "clear"
   putStrLn("Bem vindo ao gerenciador de Vacina!")
   putStrLn("Quais opções você deseja escolher?\n")
   putStrLn("\n|| Ultilize os direcionais do teclado para mover o cursor ||\n")
   showSimpleScreen opcoesTelaInicial cursor 0

   hSetBuffering stdin NoBuffering 
   hSetEcho stdin False
   action <- getKey
   doTelaInicial cursor action

--------------------------------TELA DE CADASTRO--------------------------------
opcoesTelaCadastro :: [String]
opcoesTelaCadastro = ["Realizar Cadastro De Paciente", "Cadastra Vacina", "Adiciona Vacina ao Paciente"]

mudarTelaCadastro :: Integer -> IO ()
mudarTelaCadastro cursor
   | cursor == 0 = cadastraPaciente
   | cursor == 1 = cadastraVacina
   | cursor == 2 = cadastraVacinaAoPaciente
   | otherwise = telaInicial 0


doOpcoesCadastro :: Integer -> [Char] -> IO ()
doOpcoesCadastro cursor action | action == "\ESC[B" = telaOpcaoCadastro ((cursor+1) `mod` 3)
                                                   | action == "\ESC[A" && cursor /= 0 = telaOpcaoCadastro (cursor-1)
                                                   | action == "\ESC[A" && cursor == 0 = telaOpcaoCadastro 3
                                                   | action == "\ESC[C" = mudarTelaCadastro cursor
                                                   | action == "\ESC[D" = telaInicial 0
                                                   | otherwise = telaOpcaoCadastro cursor
                                                
                                    

telaOpcaoCadastro :: Integer -> IO ()
telaOpcaoCadastro cursor = do

   system "clear"
   putStrLn("Bem vindo Usuário! \n\n || Aperte (Seta Direita) para escolher qual opcão acessar e (Seta Esquerda) para voltar à tela anterior. ||\n")                                 
   showSimpleScreen opcoesTelaCadastro cursor 0
   hSetBuffering stdin NoBuffering 
   hSetEcho stdin False
   action <- getKey
   doOpcoesCadastro cursor action 

--------------------------------TELA DE LOGIN--------------------------------
opcoesTelaLogin :: [String] 
opcoesTelaLogin = ["Visualizar Dados"]

mudarTelaLogin :: Integer -> IO()
mudarTelaLogin cursor
   | cursor == 0 = visualizaPacienteTela  
   | otherwise = telaInicial 0 


doOpcoesLogin :: Integer -> [Char] -> IO ()
doOpcoesLogin cursor action | action == "\ESC[B" = telaOpcoesLogin((cursor+1) `mod` 1)
                                                | action == "\ESC[A" && cursor /= 0 = telaOpcoesLogin (cursor-1)
                                                | action == "\ESC[D" = telaInicial 0
                                                | otherwise = telaOpcoesLogin cursor


telaOpcoesLogin :: Integer -> IO()
telaOpcoesLogin cursor = do

   system "clear"
   putStrLn ("Bem vindo Paciente! \n\n || Aperte (Seta Direita) para escolher qual opção acessar e (Seta Esquerda) para voltar à tela anterior. ||\n")
   showSimpleScreen opcoesTelaLogin cursor 0
   hSetBuffering stdin NoBuffering 
   hSetEcho stdin False 
   action <- getKey
   doOpcoesLogin cursor action


--------------------------------VISUALIZA PACIENTE--------------------------------
visualizaPacienteTela :: IO()
visualizaPacienteTela = do
   system "clear"
   pacientes <- openFile "../Data/Paciente.txt" ReadMode 
   listaPaciente <- lines <$> hGetContents pacientes
   print listaPaciente

   action <- getKey
   telaInicial 0
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
   
   action <- getKey
   telaInicial 0

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
   
   let resultado = adicionaVacina listPacientes cpfPaciente dataVacinacao idVacina
   
   escreveArquivoPaciente resultado

   --testePacientes <- getPacientesEmLista
   --print(testePacientes)
   action <- getKey
   telaInicial 0
   



-------------------------------------METODOS AUXILIARES------------------------------

getKey :: IO[Char]
getKey = reverse <$> getKey' ""
   where getKey' chars = do
         char <- getChar 
         more <- hReady stdin
         (if more then getKey' else return) (char:chars)

showSimpleScreen :: [String] -> Integer -> Integer -> IO()
showSimpleScreen [] cursor contador = return ()
showSimpleScreen (o:os) cursor contador = do
   if contador == cursor
      then
         putStrLn ("->" ++ o)
      else
         putStrLn("  " ++ o)
   showSimpleScreen os cursor (contador+1)


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


----------------------------------------------EXECUTAR--------------------------------------------------
run :: IO ()
run = do
   {catch (iniciar) error;}
   where
      iniciar = do
      {
         telaInicial 0;
         return ()
      }
      error = ioError 

main :: IO ()
main = do
   run

---------------------------------------------------------------
---------------------------------------------------------------

