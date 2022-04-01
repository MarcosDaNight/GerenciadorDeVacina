:- initialization(main).
:- include('Paciente.pl').
:- include('Vacina.pl').

/* -> FUNCOES UTEIS -- */

up(119).
down(115).
left(97).
right(100).
select(113).
remotion(101).

/* -------------------- */
upAction(0, Limit, Limit).
upAction(Cursor, _, NewCursor) :-
    NewCursor is Cursor - 1.

downAction(Cursor, Limit, NewCursor) :-
    Max is Limit + 1,
    PC is Cursor + 1,
    NewCursor is PC mod Max.

remotionExitAction(Mensagem, Resultado) :-
    shell(clear),
    writeln(Mensagem),
    get_single_char(Input),
    (remotion(Input) -> Resultado is 1;
        Resultado is 0).

showOptions([], _, _).
showOptions([A|As], Cursor, Cursor) :- 
    write('-> '),
    writeln(A),
    N is Cursor + 1,
    showOptions(As, Cursor, N).

showOptions([A|As], Cursor, N) :- 
    write('   '),
    writeln(A),
    NewN is N + 1,
    showOptions(As, Cursor, NewN).

/* -> FUNCOES PARA IO */

getString(FinalInput, Mensagem) :-
    write('\n'),
    writeln(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    FinalInput = Return.

getDouble(FinalInput, Mensagem) :-
    write('\n'),
    writeln(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    (number_string(Number, Return), Number >= 0 -> FinalInput = Number;
        getDouble(NewF, 'Entrada invalida! Tente digitar um número.\n Digite novamente!'), FinalInput is NewF).

getInt(FinalInput, Mensagem) :-
    write('\n'),
    writeln(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    (number_string(Number, Return), Number >= 0 -> FinalInput = Number;
        getDouble(NewF, 'Entrada invalida! Tente digitar um número.\n digite novamente!'), FinalInput is NewF).


/* FUNCOES PARA IO <- */
/* -> TELA PRINCIPAL */

optionsMainScreen(['Entrar como Administrador', 'Entrar como Paciente', 'Sair']).
limitMain(2).

/* ------------------------------------------------------------------------------ */

showExitMessage() :-
    shell(clear),
    writeln('----------------------------------------------'),
    writeln('* MUITO OBRIGADO POR UTILIZAR O SUSVACINA!   *'),
    writeln('*                VOLTE SEMPRE!               *'),
    writeln('----------------------------------------------\n').

doMainScreen(Cursor, Action) :-
    limitMain(Limit),
    (up(Action) -> upAction(Cursor, Limit, NewCursor), mainScreen(NewCursor);
     down(Action) -> downAction(Cursor, Limit, NewCursor), mainScreen(NewCursor);
     left(Action) -> showExitMessage();
     right(Action) -> (Cursor =:= 0 -> administradorTela(0);
                       Cursor =:= 1 -> pacienteTela(0);
                       Cursor =:= 2 -> showExitMessage());
     mainScreen(Cursor)).

menu('
    \n
███████╗██╗   ██╗███████╗██╗   ██╗ █████╗  ██████╗██╗███╗   ██╗ █████╗ 
██╔════╝██║   ██║██╔════╝██║   ██║██╔══██╗██╔════╝██║████╗  ██║██╔══██╗
███████╗██║   ██║███████╗██║   ██║███████║██║     ██║██╔██╗ ██║███████║
╚════██║██║   ██║╚════██║╚██╗ ██╔╝██╔══██║██║     ██║██║╚██╗██║██╔══██║
███████║╚██████╔╝███████║ ╚████╔╝ ██║  ██║╚██████╗██║██║ ╚████║██║  ██║
╚══════╝ ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
╔══════════════════════════════╗
║  (w,s) W: cima    S: baixo   ║
║  (a) Para modificar a tela   ║
║  (d) Selecionar opção        ║
╚══════════════════════════════╝\n').

mainScreen(Cursor) :-
    shell(clear),
    menu(X),
    writeln(X),
    optionsMainScreen(ListaOpcoes),
    showOptions(ListaOpcoes, Cursor, 0),
    get_single_char(Action),
    doMainScreen(Cursor, Action).


% ---------------------------------------- TELA VISUALIZAR PACIENTES ---------------------------------------
vizualizarPacientes() :-
    shell(clear),
    exibirPacientes(),
    get_single_char(Action),
    mainScreen(0).

% ---------------------------------------- TELA VISUALIZAR VACINA ---------------------------------------
vizualizarVacinas() :-
    shell(clear),
    exibirVacinas(),
    get_single_char(Action),
    mainScreen(0).
% ---------------------------------------- TELA CADASTRAR PACIENTE ---------------------------------------
cadastraPaciente() :-
    shell(clear),
    getString(Cpf, 'Insira o Id do paciente: '),
    getString(Nome, 'Insira o nome do paciente: '),
    getString(DataNascimento, 'Insira a data de nascimento do paciente: '),
    salvarPaciente(Cpf, Nome, DataNascimento, "", "", 0),
    write('\nPaciente foi cadastrado!'),
    get_single_char(Action),
    mainScreen(0).
%  ---------------------------------------- TELA CADASTRAR VACINA ---------------------------------------
cadastraVacina() :-
    shell(clear),
    getString(Id, 'Insira o Id da vacina: '),
    getString(Nome, 'Insira o nome da vacina: '),
    getString(QuantidadeDeDoses, 'Insira a quantidade de doses da vacina: '),
    getString(Intervalo, 'Insira o intervalo da(s) dose(s) em dias: '),
    salvarVacina(Id, Nome, QuantidadeDeDoses, Intervalo),
    write('\nVacina foi cadastrada!'),
    get_single_char(Action),
    mainScreen(0).
%  ---------------------------------------- TELA ATRIBUIR VACINA A PACIENTE ---------------------------------------
adicionaVacinaAoPaciente() :-
    shell(clear),
    getString(Cpf, 'Insira o Id do paciente: '),
    getString(Id, 'Insira o Id da vacina: '),
    getString(Data, 'Insira a data de hoje: '),
    getVacina(Id, Vacina),
    getPaciente(Cpf, Paciente),
    registrandoVacinaAoPaciente(Paciente, Vacina, Data),
    get_single_char(Action),
    mainScreen(0).
% ---------------------------------------- TELA VISUALIZAR CARTÃO DE VACINAÇÃO ---------------------------------------
vizualizarCartao() :-
    shell(clear),
    write('
    ╔══════════════════════════════╗
    ║  BEM VINDO A AREA PACIENTE   ║
    ║       INSIRA SEU CPF         ║
    ║          SUSVACINA           ║
    ╚══════════════════════════════╝\n'),
    getString(Cpf, 'Insira o Id do paciente: '),
    exibirPaciente(Cpf),
    get_single_char(Action),
    mainScreen(0).

% ---------------------------------------------TELA OPCOES ADMINISTRADOR-----------------------------------------------------------
opcoesAdministrador(['Visualizar Pacientes', 'Vizualizar Vacinas', 'Cadastrar Paciente', 'Cadastrar Vacina', 'Registrar Vacinação']).
limitAdministrador(4).

doAdministradorTela(Cursor, Action) :-
    limitAdministrador(Limit),
    (up(Action) -> upAction(Cursor, Limit, NewCursor), administradorTela(NewCursor);
     down(Action) -> downAction(Cursor, Limit, NewCursor), administradorTela(NewCursor);
     left(Action) -> mainScreen(Cursor);
     right(Action) -> (Cursor =:= 0 -> vizualizarPacientes();
                       Cursor =:= 1 -> vizualizarVacinas();
                       Cursor =:= 2 -> cadastraPaciente();
                       Cursor =:= 3 -> cadastraVacina();
                       Cursor =:= 4 -> adicionaVacinaAoPaciente());
     administradorTela(Cursor)).

administradorTela(Cursor) :-
    shell(clear),
    menu(X),
    writeln(X),
    opcoesAdministrador(ListaOpcoes),
    showOptions(ListaOpcoes, Cursor, 0),
    get_single_char(Action),
    doAdministradorTela(Cursor, Action).

% ---------------------------------------------TELA OPCOES PACIENTE-----------------------------------------------------------
opcoesPaciente(['Visualizar Cartão de Vacinação', 'Visualizar Características da Vacina']).
limitPaciente(1).

doPacienteTela(Cursor, Action) :-
    limitPaciente(Limit),
    (up(Action) -> upAction(Cursor, Limit, NewCursor), pacienteTela(NewCursor);
     down(Action) -> downAction(Cursor, Limit, NewCursor), pacienteTela(NewCursor);
     left(Action) -> mainScreen(Cursor);
     right(Action) -> (Cursor =:= 0 -> vizualizarCartao(); 
                       Cursor =:= 1 -> vizualizarVacinas());
     pacienteTela(Cursor)).

pacienteTela(Cursor) :-
    shell(clear),
    menu(X),
    writeln(X),
    opcoesPaciente(ListaOpcoes),
    showOptions(ListaOpcoes, Cursor, 0),
    get_single_char(Action),
    doPacienteTela(Cursor, Action).

main :-
    mainScreen(0),
    halt(0).