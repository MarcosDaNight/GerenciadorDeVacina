:- use_module(library(http/json)).


lerJSON(FilePath, File) :-
		open(FilePath, read, F),
		json_read_dict(F, File).

% Regras para listar todos Pacientes
exibirPacientesAux([]).
exibirPacientesAux([H|T]) :- nl,
	write("----------------------"),
    write("ID:"), writeln(H.id),
	write("Nome:"), writeln(H.nomePaciente), 
	write("Data de Nascimento:"), writeln(H.dataNascimento), nl,
	write("Data de Vacinacao:"), writeln(H.dataVacinacao), nl,
	write("Vacina:"), writeln(H.vacina), nl, 
	write("Quantidade de doses tomadas:"), writeln(H.quantidadeDeDoses), nl, 
	exibirPacientesAux(T).

exibirPacientes() :-
		lerJSON("../Data/paciente.json", T),
		exibirPacientesAux(T).

% Regras para listar um Paciente
exibirPacienteAux([H|T], Id) :- H.id \= Id, exibirPacienteAux(T, Id).
exibirPacienteAux([H|T], Id) :- H.id =:= Id, exibirPacienteString(H,Id).
exibirPacienteString(H,Id) :- nl,
	write("----------------------"),
    write("CPF:"), writeln(H.id), nl,
	write("Nome:"), writeln(H.nomePaciente), nl,
	write("Data de Nascimento:"), writeln(H.dataNascimento), nl,
	write("Data de Vacinacao:"), writeln(H.dataVacinacao), nl,
	write("Vacina:"), writeln(H.vacina), nl.
	write("Quantidade de doses tomadas:"), writeln(H.quantidadeDeDoses), nl.


exibirPaciente(FilePath, Id) :-
		lerJSON(FilePath, T),
		exibirPacienteAux(T, Id).

% Criando representação em formato String de um Paciente em JSON
pacienteToJSON(ID, Nome, DataNascimento, DataVacinacao, Vacina, QtdDoses, Out) :-
		swritef(Out, '{"id":"%w","nomePaciente":"%w","dataNascimento":"%w","dataVacinacao":"%w","vacina":"%w","quantidadeDeDoses":%w}', [ID, Nome, DataNascimento, DataVacinacao, Vacina, QtdDoses]).

% Convertendo uma lista de objetos em JSON para 
pacientesToJSON([], []).
pacientesToJSON([H|T], [X|Out]) :- 
		pacienteToJSON(H.id, H.nomePaciente, H.dataNascimento, H.dataVacinacao, H.vacina, H.quantidadeDeDoses, X), 
		pacientesToJSON(T, Out).

% Salvar em arquivo JSON
salvarPaciente(Cpf, Nome, Nascimento, DataVacinacao, Vacina, QtdDoses) :- 
		lerJSON("../Data/paciente.json", File),
		pacientesToJSON(File, ListaPacientesJSON),
		pacienteToJSON(Cpf, Nome, Nascimento, DataVacinacao, Vacina, QtdDoses, PacienteJSON),
		append(ListaPacientesJSON, [PacienteJSON], Saida),
		open("../Data/paciente.json", write, Stream), write(Stream, Saida), close(Stream).

% Mudando o nome de um Paciente 
editarNomePacienteJSON([], _, _, []).
editarNomePacienteJSON([H|T], H.id, Nome, [_{id:H.id, nomePaciente:Nome, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:H.vacina}|T]).
editarNomePacienteJSON([H|T], Id, Nome, [H|Out]) :- 
		editarNomePacienteJSON(T, Id, Nome, Out).
 
editarNomePaciente(IdPaciente, NovoNome) :-
		lerJSON("../Data/paciente.json", File),
		editarNomePacienteJSON(File, IdPaciente, NovoNome, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open("../Data/paciente.json", write, Stream), write(Stream, Saida), close(Stream).

% Adicionando Vacina ao paciente
adicionaVacinaAoPacienteJSON([], _, _, _, []).
adicionaVacinaAoPacienteJSON([H|T], H.id, Vacina, QtdDoses, [_{id:H.id, nomePaciente:H.nomePaciente, dataNascimento:H.dataNascimento, dataVacinacao:H.dataVacinacao, vacina:Vacina, quantidadeDeDoses:H.quantidadeDeDoses}|T]).
adicionaVacinaAoPacienteJSON([H|T], Id, Vacina, [H|Out]) :- 
		adicionaVacinaAoPacienteJSON(T, Id, Vacina, Out).

adicionaVacinaAoPaciente(IdPaciente, Vacina, QtdDoses) :-
		lerJSON("../Data/paciente.json", File),
		adicionaVacinaAoPacienteJSON(File, IdPaciente, Vacina, QtdDoses, SaidaParcial),
		pacientesToJSON(SaidaParcial, Saida),
		open("../Data/paciente.json", write, Stream), write(Stream, Saida), close(Stream).

% Removendo Paciente
removerPacienteJSON([], _, []).
removerPacienteJSON([H|T], H.id, T).
removerPacienteJSON([H|T], Id, [H|Out]) :- removerPacienteJSON(T, Id, Out).

removerPaciente(Id) :-
   lerJSON("../Data/paciente.json", File),
   removerPacienteJSON(File, Id, SaidaParcial),
   pacientesToJSON(SaidaParcial, Saida),
   open("../Data/paciente.json", write, Stream), write(Stream, Saida), close(Stream).

getPaciente(IdPaciente) :-
	lerJSON("../Data/paciente.json", File),
	getPacienteJSON(File, IdPaciente, SaidaParcial),
	write(SaidaParcial.quantidadeDeDoses).

% Mudando o nome de um Paciente
getPacienteJSON([], _, _).
getPacienteJSON([H|T], H.id, H).
getPacienteJSON([H|T], Id, Out) :- 
		getPacienteJSON(T, Id, Out).

% Pegando quantidade de doses da vacina
getDosesJSON([], _,_).
getDosesJSON([H|T], H.id, H.quantidadeDeDoses).
getDosesJSON([H|T], Id, Out) :-
    getDosesJSON(T, Id, Out).

getDoses(Id, SaidaParcial):-
    lerJSON("../Data/paciente.json", File),
    getDosesJSON(File, Id, SaidaParcial),
	write(SaidaParcial).