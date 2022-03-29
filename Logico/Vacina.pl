:- use_module(library(http/json)).

% Gerando id atráves de fato dinâmico
%id(1).
%incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
%/home/marcosgdn/Documentos/PLP/GerenciadorDeVacina/Data/vacina.json

% Lendo JSON

lerJSON(FilePath, File) :-
    open(FilePath, read, F),
    json_read_dict(F, File).

% Regra para listar vacinas
exibirVacinasAux([]).
exibirVacinasAux([H|T]) :-
    write("ID:"), writeln(H.id),
    write("Nome da Vacina:"), writeln(H.nomeVacina),
    write("Data da vacinacao:"), writeln(H.dataVacinacao),
    write("Quantidade de doses:"), writeln(H.quantidadeDeDoses), nl, exibirVacinasAux(T).


exibirVacinas(FilePath) :-
    lerJSON(FilePath, T),
    exibirVacinasAux(T).

% Regra para listar uma vacina
exibirVacinaAux([H|T], Id) :- H.id \= Id, exibirVacinaAux(T, Id).
exibirVacinaAux([H|T], Id) :- H.id =:= Id, exibirVacinaString(H, Id).
exibirVacinaString(H, Id) : nl,
    write("ID:"), writeln(H.id), nl,
    write("Nome da Vacina:"), writeln(H.nomeVacina), nl,
    write("Data da vacinacao:"), writeln(H.dataVacinacao), nl,
    write("Quantidade de doses:"), writeln(H.quantidadeDeDoses), nl.


exibirVacina(FilePath, Id) :-
    lerJSON(FilePath, T),
    exibirVacinaAux(T, Id).

% Criando uma representação em string para uma vacina em JSON
vacinaToJSON(ID, NomeVacina, DataVacinacao, QuantidadeDeDoses, Out) :-
    swritef(Out, '{"id":"%w", "nomeVacina": "%w", "dataVacinacao": "%w", "quantidadeDeDoses": "%w"',[ID, NomeVacina, DataVacinacao, QuantidadeDeDoses]).

% Convertendo uma lista de objetos para JSON
vacinasToJSON([], []).
vacinasToJSON([H|T], [X|Out]) :-
    vacinaToJSON(H.id, H.nomeVacina, H.dataVacinacao, H.quantidadeDeDoses, X),
    vacinaToJSON(T, Out)

% Salvando em JSON
salvarVacina(FilePath, Id, NomeVacina, DataVacinacao, QuantidadeDeDoses) :-
    lerJSON(FilePath, File),
    vacinasToJSON(File, ListaVacinasJSON),
    vacinaToJSON(Id, NomeVacina, DataVacinacao, QuantidadeDeDoses, VacinaJSON)
    append(ListaVacinasJSON, [VacinaJSON], Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Alterando nome de uma Vacina
editarNomeVacinaJSON([], _, _, []).
editarNomeVacinaJSON([H|T], H.id, NomeVacina, [_{id:H.id, nomeVacina:NomeVacina, dataVacinacao:H.dataVacinacao, quantidadeDeDoses:H.quantidadeDeDoses}|T]).
editarNomeVacinaJSON([H|T], Id, Nome, [H|Out]) :-
    editarNomeVacinaJSON(T, Id, Nome, Out).

editarNomeVacina(FilePath, IdVacina, NovoNome) :-
    lerJSON(FilePath, File),
    editarNomeVacinaJSON(File, IdVacina, NovoNome, SaidaParcial),
    vacinasToJSON(SaidaParcial, Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).


% Alterando data de uma Vacina
editarDataVacinaoJSON([], _, _, []).
editarDataVacinaoJSON([H|T], H.id, DataVacinao, [_{id:H.id, nomeVacina: H.nomeVacina, dataVacinao:data, DataVacinaocao:DataVacinao, quantidadeDeDoses:H.quantidadeDeDoses}|T]).
editarDataVacinaoJSON([H|T], Id, DataVacinacao, [H|Out]) :-
    editarDataVacinaoJSON(T, Id, DataVacinacao, Out).

editarDataVacinao(FilePath, IdVacina, Novadata) :-
    lerJSON(FilePath, File),
    editarDataVacinaoJSON(File, IdVacina, NovoData, SaidaParcial),
    vacinasToJSON(SaidaParcial, Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).



% Alterando quantidade de doses de uma Vacina
editarQuantidadeDeDosesJSON([], _, _, []).
editarQuantidadeDeDosesJSON([H|T], H.id, QuantidadeDeDoses, [_{id:H.id, nomeVacina: H.nomeVacina, dataVacinao:H.dataVacinacao, quantidadeDeDoses:H.quantidadeDeDoses}|T]).
editarQuantidadeDeDosesJSON([H|T], Id, QuantidadeDeDoses, [H|Out]) :-
    editarDataVacinaoJSON(T, Id, QuantidadeDeDoses, Out).

editarDataVacinao(FilePath, IdVacina, NovaQuantidade) :-
    lerJSON(FilePath, File),
    editarDataVacinaoJSON(File, IdVacina, NovaQuantidade, SaidaParcial),
    vacinasToJSON(SaidaParcial, Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% Remover Paciente
removerVacinaJSON([], _, []).
removerVacinaJSON([H|T], H.id, T).
removerVacinaJSON([H|T], Id, [H|Out]) :- removerVacinaJSON(T, Id, Out).





    
