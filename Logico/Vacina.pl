:- use_module(library(http/json)).

% Lendo JSON
lerJSON(FilePath, File) :-
    open(FilePath, read, F),
    json_read_dict(F, File).

% Regra para listar vacinas
exibirVacinasAux([]).
exibirVacinasAux([H|T]) :- nl,
	write("----------------------"),
    write("ID: "), writeln(H.id),
    write("Nome da Vacina: "), writeln(H.nomeVacina),
    write("Quantidade de doses: "), writeln(H.quantidadeDeDoses), nl,
    write("Intervalo de doses: "), writeln(H.intervalo), nl,
    exibirVacinasAux(T).


exibirVacinas() :-
    lerJSON("../Data/vacina.json", T),
    exibirVacinasAux(T).

% Regra para listar uma vacina
exibirVacinaAux([H|T], Id) :- H.id \= Id, exibirVacinaAux(T, Id).
exibirVacinaAux([H|T], Id) :- H.id =:= Id, exibirVacinaString(H, Id).
exibirVacinaString(H, Id) :- nl,
	write("----------------------"),
    write("ID:"), writeln(H.id), nl,
    write("Nome da Vacina:"), writeln(H.nomeVacina), nl,
    write("Quantidade de doses:"), writeln(H.quantidadeDeDoses), nl,
    write("Intervalo de doses: "), writeln(H.intervalo), nl.


exibirVacina(Id) :-
    lerJSON("../Data/vacina.json", T),
    exibirVacinaAux(T, Id).

% Criando uma representação em string para uma vacina em JSON
vacinaToJSON(Id, NomeVacina, QuantidadeDeDoses, Intervalo, Out) :-
swritef(Out, '{"id":"%w","nomeVacina":"%w","quantidadeDeDoses":%w,"intervalo":"%w dias"}',[Id, NomeVacina, QuantidadeDeDoses, Intervalo]).

% Convertendo uma lista de objetos para JSON
vacinasToJSON([], []).
vacinasToJSON([H|T], [X|Out]) :-
    vacinaToJSON(H.id, H.nomeVacina, H.quantidadeDeDoses, H.intervalo, X),
    vacinasToJSON(T, Out).

salvarVacina(Id, NomeVacina, QuantidadeDeDoses, Intervalo) :- 
		lerJSON("../Data/vacina.json", File),
        vacinasToJSON(File, ListaVacinasJSON),
        vacinaToJSON(Id, NomeVacina, QuantidadeDeDoses, Intervalo, VacinaJSON),
        append(ListaVacinasJSON, [VacinaJSON], Saida),
        open("../Data/vacina.json", write, Stream), write(Stream, Saida), close(Stream).

% Alterando quantidade de doses de uma Vacina
editarQuantidadeDeDosesJSON([], _, _, []).
editarQuantidadeDeDosesJSON([H|T], H.id, QuantidadeDeDoses, [_{id:H.id, nomeVacina: H.nomeVacina, quantidadeDeDoses:QuantidadeDeDoses, intervalo: H.intervalo}|T]).
editarQuantidadeDeDosesJSON([H|T], Id, QuantidadeDeDoses, [H|Out]) :-
    editarQuantidadeDeDosesJSON(T, Id, QuantidadeDeDoses, Out).

editarQuantidadeDeDoses(IdVacina, NovaQuantidade) :-
    lerJSON("../Data/vacina.json", File),
    editarQuantidadeDeDosesJSON(File, IdVacina, NovaQuantidade, SaidaParcial),
    vacinasToJSON(SaidaParcial, Saida),
    open("../Data/vacina.json", write, Stream), write(Stream, Saida), close(Stream).

% Remover Paciente
removerVacinaJSON([], _, []).
removerVacinaJSON([H|T], H.id, T).
removerVacinaJSON([H|T], Id, [H|Out]) :- removerVacinaJSON(T, Id, Out).

getVacina(IdVacina, SaidaParcial) :-
	lerJSON("../Data/vacina.json", File),
	getVacinaJSON(File, IdVacina, SaidaParcial).

% Mudando o nome de um Vacina
getVacinaJSON([], _, _).
getVacinaJSON([H|T], H.id, H).
getVacinaJSON([H|T], Id, Out) :- 
		getVacinaJSON(T, Id, Out).