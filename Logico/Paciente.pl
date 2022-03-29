:- use_module(library(http/json)).

% Fato dinâmico para gerar o id dos pacientes
%id(1).
%incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
%:- dynamic id/1.
% C:/Users/pedro/Documents/PLP/GerenciadorDeVacina/Data/Logico/pacientes.json
% Lendo arquivo JSON puro
lerJSON(FilePath, File) :-
		open(FilePath, read, F),
		json_read_dict(F, File).

% Regras para listar todos Pacientes
exibirPacientesAux([]).
exibirPacientesAux([H|T]) :- 
    write("ID:"), writeln(H.id),
	write("Nome:"), writeln(H.nomePaciente), 
	write("Data de Nascimento:"), writeln(H.dataNascimento), nl,
	write("Data de Vacinacao:"), writeln(H.dataVacinacao), nl,
	write("Vacina:"), writeln(H.vacina), nl, exibirPacientesAux(T).

exibirPacientes(FilePath) :-
		lerJSON(FilePath, T),
		exibirPacientesAux(T).

% Criando representação em formato String de um Paciente em JSON
pacienteToJSON(ID, Nome, DataNascimento, DataVacinacao, Vacina, Out) :-
		swritef(Out, '{"id":"%w","nomePaciente":"%w","dataNascimento":"%w","dataVacinacao":"%w","vacina":"%w"}', [ID, Nome, DataNascimento, DataVacinacao, Vacina]).

% Convertendo uma lista de objetos em JSON para 
pacientesToJSON([], []).
pacientesToJSON([H|T], [X|Out]) :- 
		pacienteToJSON(H.id, H.nomePaciente, H.dataNascimento, H.dataVacinacao, H.vacina, X), 
		pacientesToJSON(T, Out).

% Salvar em arquivo JSON
salvarPaciente(FilePath, Nome, Nascimento, DataVacinacao, Vacina) :- 
    id(ID), incrementa_id,
		lerJSON(FilePath, File),
		pacientesToJSON(File, ListaPacientesJSON),
		pacienteToJSON(ID, Nome, Nascimento, DataVacinacao, Vacina, PacienteJSON),
		append(ListaPacientesJSON, [PacienteJSON], Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Mudando o nome de um Paciente 
editarNomePacienteJSON([], _, _, []).
editarNomePacienteJSON([H|T], H.id, Nome, [_{id:H.id, nome:Nome, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:H.vacina}|T]).
editarNomePacienteJSON([H|T], Id, Nome, [H|Out]) :- 
		editarNomePacienteJSON(T, Id, Nome, Out).
 
editarNomePaciente(FilePath, IdPaciente, NovoNome) :-
		lerJSON(FilePath, File),
		editarNomePacienteJSON(File, IdPaciente, NovoNome, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Adicionando Vacina ao paciente
adicionaVacinaAoPacienteJSON([], _, _, []).
adicionaVacinaAoPacienteJSON([H|T], H.id, Vacina, [_{id:H.id, nome:H.nomePaciente, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:Vacina}|T]).
adicionaVacinaAoPacienteJSON([H|T], Id, Vacina, [H|Out]) :- 
		adicionaVacinaAoPacienteJSON(T, Id, Vacina, Out).

adicionaVacinaAoPaciente(FilePath, IdPaciente, Vacina) :-
		lerJSON(FilePath, File),
		adicionaVacinaAoPacienteJSON(File, IdPaciente, Vacina, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Removendo Paciente
removerPacienteJSON([], _, []).
removerPacienteJSON([H|T], H.id, T).
removerPacienteJSON([H|T], Id, [H|Out]) :- removerPacienteJSON(T, Id, Out).

removerPaciente(FilePath, Id) :-
   lerJSON(FilePath, File),
   removerPacienteJSON(File, Id, SaidaParcial),
   pacientesToJSON(SaidaParcial, Saida),
   open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

getPaciente(FilePath, IdPaciente) :-
	lerJSON(FilePath, File),
	getPacienteJSON(File, IdPaciente, SaidaParcial),
	pacientesToJSON(SaidaParcial, Saida),
	open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Mudando o nome de um Paciente
getPacienteJSON([], _, []).
getPacienteJSON([H|T], Id, [H|T]) := H.id =:= Id, write(H.nomePaciente).
getPacienteJSON([H|T], Id, [H|Out]) :- 
		getPacienteJSON(T, Id, Out).