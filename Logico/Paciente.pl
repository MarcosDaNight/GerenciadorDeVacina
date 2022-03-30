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

exibirPacientes() :-
		lerJSON("/home/marcosgdn/Documentos/PLP/GerenciadorDeVacina/Data/paciente.json", T),
		exibirPacientesAux(T).

% Regras para listar um Paciente
exibirPacienteAux([H|T], Id) :- H.id \= Id, exibirPacienteAux(T, Id).
exibirPacienteAux([H|T], Id) :- H.id =:= Id, exibirPacienteString(H,Id).
exibirPacienteString(H,Id) :- nl,
    write("CPF:"), writeln(H.id), nl,
	write("Nome:"), writeln(H.nomePaciente), nl,
	write("Data de Nascimento:"), writeln(H.dataNascimento), nl,
	write("Data de Vacinacao:"), writeln(H.dataVacinacao), nl,
	write("Vacina:"), writeln(H.vacina), nl.


exibirPaciente(FilePath, Id) :-
		lerJSON(FilePath, T),
		exibirPacienteAux(T, Id).

% Criando representação em formato String de um Paciente em JSON
pacienteToJSON(ID, Nome, DataNascimento, DataVacinacao, Vacina, Out) :-
		swritef(Out, '{"id":"%w","nomePaciente":"%w","dataNascimento":"%w","dataVacinacao":"%w","vacina":"%w"}', [ID, Nome, DataNascimento, DataVacinacao, Vacina]).

% Convertendo uma lista de objetos em JSON para 
pacientesToJSON([], []).
pacientesToJSON([H|T], [X|Out]) :- 
		pacienteToJSON(H.id, H.nomePaciente, H.dataNascimento, H.dataVacinacao, H.vacina, X), 
		pacientesToJSON(T, Out).

% Salvar em arquivo JSON
salvarPaciente(FilePath, Cpf, Nome, Nascimento, DataVacinacao, Vacina) :- 
		lerJSON(FilePath, File),
		pacientesToJSON(File, ListaPacientesJSON),
		pacienteToJSON(Cpf, Nome, Nascimento, DataVacinacao, Vacina, PacienteJSON),
		append(ListaPacientesJSON, [PacienteJSON], Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Mudando o nome de um Paciente 
editarNomePacienteJSON([], _, _, []).
editarNomePacienteJSON([H|T], H.id, Nome, [_{id:H.id, nomePaciente:Nome, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:H.vacina}|T]).
editarNomePacienteJSON([H|T], Id, Nome, [H|Out]) :- 
		editarNomePacienteJSON(T, Id, Nome, Out).
 
editarNomePaciente(FilePath, IdPaciente, NovoNome) :-
		lerJSON(FilePath, File),
		editarNomePacienteJSON(File, IdPaciente, NovoNome, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Adicionando Vacina ao paciente
adicionaVacinaAoPacienteJSON([], _, _, []).
adicionaVacinaAoPacienteJSON([H|T], H.id, Vacina, [_{id:H.id, nomePaciente:H.nomePaciente, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:Vacina}|T]).
adicionaVacinaAoPacienteJSON([H|T], Id, Vacina, [H|Out]) :- 
		adicionaVacinaAoPacienteJSON(T, Id, Vacina, Out).

adicionaVacinaAoPaciente(FilePath, IdPaciente, Vacina) :-
		lerJSON(FilePath, File),
		adicionaVacinaAoPacienteJSON(File, IdPaciente, Vacina, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Adicionando Vacina a lista de vacinas do paciente (só conceito, não funciona ainda)
adcVacinaAoPacienteJSON([], _, _, []).
adcVacinaAoPacienteJSON([H|T], H.id, Vacina, [_{id:H.id, nomePaciente:H.nomePaciente, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:Vacina}|T]).
adcVacinaAoPacienteJSON([H|T], Id, Vacina) :- write('cu'), write(T), write(Vacina), Id =:= H.id.


adcVacinaAoPaciente(FilePath, IdPaciente, Vacina) :-
		lerJSON(FilePath, File),
		adcVacinaAoPacienteJSON(File, IdPaciente, Vacina, SaidaParcial),
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