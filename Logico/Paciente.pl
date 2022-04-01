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
	write("\n----------------------\n"),
    write("CPF: "), writeln(H.id), nl,
	write("Nome: "), writeln(H.nomePaciente), nl,
	write("Data de Nascimento: "), writeln(H.dataNascimento), nl,
	write("Data de Vacinacao: "), writeln(H.dataVacinacao), nl,
	write("Vacina: "), writeln(H.vacina), nl,
	write("Quantidade de doses tomadas: "), writeln(H.quantidadeDeDoses), nl.


exibirPaciente(Id) :-
		lerJSON("../Data/paciente.json", T),
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

% Adicionando Vacina ao paciente
adicionaVacinaAoPacienteJSON([], _, _, _, _, []).
adicionaVacinaAoPacienteJSON([H|T], H.id, Vacina, QtdDoses, Data, [_{id:H.id, nomePaciente:H.nomePaciente, dataNascimento:H.dataNascimento, dataVacinacao:Data, vacina:Vacina, quantidadeDeDoses:QtdDoses}|T]).
adicionaVacinaAoPacienteJSON([H|T], Id, Vacina, QtdDoses, Data, [H|Out]) :- 
		adicionaVacinaAoPacienteJSON(T, Id, Vacina, QtdDoses, Data, Out).

adicionaVacinaAoPaciente(IdPaciente, Vacina, QtdDoses, Data) :-
		lerJSON("../Data/paciente.json", File),
		adicionaVacinaAoPacienteJSON(File, IdPaciente, Vacina, QtdDoses, Data, SaidaParcial),
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

getPaciente(IdPaciente, SaidaParcial) :-
	lerJSON("../Data/paciente.json", File),
	getPacienteJSON(File, IdPaciente, SaidaParcial).

% Mudando o nome de um Paciente
getPacienteJSON([], _, _).
getPacienteJSON([H|T], H.id, H).
getPacienteJSON([H|T], Id, Out) :- 
		getPacienteJSON(T, Id, Out).


% Registrando vacina ao paciente
registrandoVacinaAoPaciente(Paciente, Vacina, Data):- 
	Paciente.quantidadeDeDoses =:=  Vacina.quantidadeDeDoses,
	write("Paciente já tomou todas as doses\n").

registrandoVacinaAoPaciente(Paciente, Vacina, Data):-
	Paciente.quantidadeDeDoses < Vacina.quantidadeDeDoses,
	incrementaQtnDeDoses(Paciente.quantidadeDeDoses, R),
	adicionaVacinaAoPaciente(Paciente.id, Vacina.nomeVacina, R, Data),
	write("Dose aplicada ao paciente!\n").

incrementaQtnDeDoses(A, R):-
	R is A+1.