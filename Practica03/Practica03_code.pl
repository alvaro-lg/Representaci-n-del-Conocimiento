%base de conocimiento
%parent/2
parent( pam, bob).
parent( tom, bob).
parent( tom, liz).
parent( bob, ann).
parent( bob, pat).
parent( pat, jim).
parent( pamela, leo).
parent( torn, leo).
parent( torn, isa).
parent( leo, ana).
parent( leo, patricia).
parent( patricia, jaime).

%woman/1
woman(pamela).
woman(isa).
woman(ana).
woman(patricia).

%man/1
man(torn).
man(leo).
man(jaime).

%sex/2
sex( pam, feminine).
sex( tom, masculine).
sex( bob, masculine).
sex( pat, feminine).

%predicados
%mother/2
mother(X,Y):- parent(X,Y), sex(X, feminine).
%sister/2
sister(X,Y):- parent(Z,X), parent(Z,Y), woman(X).
%feliz/1
feliz(X):- parent(X,_).
%pareja/1
pareja(X):- parent(X,Y), sister(_,Y).
%ancestro/2
ancestro(X,Y):- parent(X,Z), parent(Z,Y).

%cuestion 3
%predicados de listas
%posicion/3
posicion(E,L,P):- es_miembro(E,L,P).
%es_miembro/3
es_miembro(Elemento, [Cabeza| Cola], P):- Elemento = Cabeza, P is 0.
es_miembro(Elemento, [Cabeza| Cola], P):- P1 is P - 1, es_miembro(Elemento, Cola, P1).

%cuestion 4
%Problema de los sobrinos de Donald y Daisy
ninos(S):-
 %nombre, edad, animal, color
 member([dewey,_,_ ,amarillo], S), % restriccion 3
 member([_,5,camello,_],S), % restriccion 2
 member([louie,_,jirafa, _], S), % restriccion 4
 todos([dewey, louie, huey], S,0),
 todos([4, 5, 6], S, 1),
 todos([oso, jirafa, camello], S, 2),
 todos([verde, amarillo, blanco], S, 3),
 restriccion(huey, verde, S), % restriccion 1
 (member([_,_,oso,amarillo], S);member([_,_,oso,verde], S)),!. % restriccion 5

% Huey tiene menos edad que el sobrino con la camiseta verde.
restriccion(Nombre, Color, S):-
 (member([Nombre,4, _,_], S), member([_, 5, _,Color],S));
 (member([Nombre,4, _,_], S), member([_, 6, _,Color],S));
 (member([Nombre,5, _,_], S), member([_, 6, _,Color],S)).


todos([X], [L| _], Pos):- nth0(Pos, L, X).
todos([X], [ _ |L2], Pos):- todos([X], L2, Pos).
todos([X|Y], [L], Pos):- nth0(Pos, L, X), todos(Y, [L], Pos).
todos([X|Y], [L1|L2], Pos):- nth0(Pos, L1, X), todos(Y,L2, Pos).
todos([X|Y], [L1|L2], Pos):- todos([X], L2, Pos), todos(Y,[L1|L2], Pos).

% Cuestion 5
% El problema del robot de limpieza
% El estado se compone de tres posiciones, la posicion del robot, de
% la papelera y la basura.
estado(cuadricula(1,1),cuadricula(1,2), cuadricula(1,3)).

% El robot puede soltar la basura si esta cargada y estamos al lado de la papelera.
accion(estado(Pos1,Pos1, cargada), soltar, estado(Pos1, Pos1, en_papelera)).
% El robot puede recoger la basura si esta encima de ella.
accion(estado(Pos1,Pos2, Pos1), recoger, estado(Pos1, Pos2, cargada)).
% El robot puede moverse entre las distintas posiciones.
accion(estado(Pos1,Pos2, Pos3), ir(Pos1,Pos4), estado(Pos4, Pos2, Pos3)).

%% Los planes empiezan en un estado y acaban en otro.
plan(Estado, Estado, []). 

plan(Inicio, Fin, [Accion1|Resto]) :-
	accion(Inicio, Accion1, Estado),
    plan(Estado,Fin,Resto), !.

%%:-plan(estado(cuadricula(1,1),cuadricula(1,2),cuadricula(1,3)),estado(_,_,en_papelera),Plan),write(Plan).


% Cuestion 6
% El estado se compone de tres posiciones, la posicion del robot, de
% la papelera y la basura.
estado(cuadricula(1,1),cuadricula(1,2), cuadricula(1,3)).

ir(cuadricula(X1, Y1), cuadricula(X2, Y2), cuadricula(X3, Y3)):-
	abs(X3 - X1) > abs(Y3 - Y1),
    X2 is X1 + sign(X3 - X1),
	Y2 is Y1.
    
ir(cuadricula(X1, Y1), cuadricula(X2, Y2), cuadricula(X3, Y3)):-
	abs(Y3 - Y1) >= abs(X3 - X1),
    Y2 is Y1 + sign(Y3 - Y1),
	X2 is X1.

camino(cuadricula(X, Y), cuadricula(X, Y),[cuadricula(X , Y)]).

camino(cuadricula(X1, Y1), cuadricula(X2, Y2), [cuadricula(X1, Y1)|Tail]):-
    ir(cuadricula(X1, Y1), Pos, cuadricula(X2, Y2)),
    camino(Pos, cuadricula(X2, Y2), Tail),!.

% El robot puede soltar la basura si esta cargada y estamos al lado de la papelera.
accion(estado(Pos1, Pos1, cargada), soltar, estado(Pos1, Pos1, en_papelera)).
% El robot puede recoger la basura si esta encima de ella.
accion(estado(Pos1, Pos2, Pos1), recoger, estado(Pos1, Pos2, cargada)).
% El robot puede moverse entre las distintas posiciones.
accion(estado(Pos1, Pos2, cargada), ir(Pos1, Pos4), estado(Pos4, Pos2, cargada)):-
    ir(Pos1, Pos4, Pos2).
accion(estado(Pos1, Pos2, Pos3), ir(Pos1, Pos4), estado(Pos4, Pos2, Pos3)):-
    ir(Pos1, Pos4, Pos3).

%% Los planes empiezan en un y acaban en otro.
plan(Estado, Estado, []). 

plan(Inicio, Fin, [Accion1|Resto]) :-
	accion(Inicio, Accion1, Estado),
    plan(Estado,Fin,Resto), !.
%%Consulta Plan:- plan(estado(cuadricula(1,1),cuadricula(1,2),cuadricula(1,3)),estado(_,_,en_papelera),Plan),write(Plan).
%%Consulta Camino:- camino(cuadricula(3, 5), cuadricula(5, 3), Camino).


% Cuestion 7
% El problema de los horarios de autobuses
:- op( 100, xfx, salida).
:- op( 50, xfx,:).
% Horario entre las siguientes localidades cantabras.
% horario( StartPLace salida StartTime, EndPlace salida EndTime, Horario)
horario( [ santander salida 8:00, guarnizo salida 8:35, solares salida 8:55 ]).
% Empezamos en Santander salida 8:00, llegamos a guarnizo salida 8:35, seguimos a solares, salida 8:55
%
horario( [ santander salida 9:10, lierganes salida 9:25, guarnizo salida 9:55, solares salida 10:15 ]).
horario( [ santander salida 9:45, lierganes salida 10:00, guarnizo salida 10:30, solares salida 10:50 ]).
horario( [ santander salida 11:45, lierganes salida 12:00, guarnizo salida 12:30, solares salida 12:50 ]).
horario( [ santander salida 13:10, guarnizo salida 13:32, solares salida 13:45 ]).
horario( [ santander salida 14:05, guarnizo salida 14:40, solares salida 15:00 ]).
horario( [ santander salida 15:00, guarnizo salida 15:36, solares salida 15:57, beranga salida 16:13 ]).
horario( [ santander salida 16:20, lierganes salida 16:35, guarnizo salida 17:05, solares salida 17:25 ]).
horario( [ santander salida 18:05, lierganes salida 18:20, guarnizo salida 18:50, solares salida 19:10 ]).
horario( [ solares salida 9:00, guarnizo salida 9:20, lierganes salida 9:50, santander salida 10:05 ]).
horario( [ solares salida 10:25, guarnizo salida 10:50, lierganes salida 11:20, santander salida 11:35 ]).
horario( [ solares salida 11:25, guarnizo salida 11:45, santander salida 12:20 ]).
horario( [ beranga salida 12:55, solares salida 13:12, guarnizo salida 13:34, santander salida 14:10 ]).
horario( [ solares salida 13:45, guarnizo salida 13:59, santander salida 14:20 ]).
horario( [ solares salida 15:05, guarnizo salida 15:25, santander salida 16:00 ]).
horario( [ solares salida 16:30, guarnizo salida 16:50, lierganes salida 17:20, santander salida 17:35 ]).
horario( [ solares salida 18:15, guarnizo salida 18:35, lierganes salida 19:05, santander salida 19:20 ]).
horario( [ solares salida 19:15, guarnizo salida 19:35, lierganes salida 20:05, santander salida 20:20 ]).

plan1( Inicio, Destino, [ salida(Inicio), llegada( Siguiente) | Resto]) :-
 list( Resto),
 transbordo( Inicio, Siguiente),
 resto_horario(Siguiente ,Destino, Resto).

resto_horario( Sitio, Sitio, []).

resto_horario( Sitio salida Hora1, Destino, [ esperar( Sitio, Hora1, Hora2) | Resto]) :-
 transbordo( Sitio salida Hora2, _),
 es_antes(Hora1, Hora2),
 resto_horario( Sitio salida Hora2, Destino, Resto).

resto_horario( Ahora, Destino, [ llegada( Siguiente) | Resto]) :-
 transbordo( Ahora, Siguiente),
 resto_horario( Siguiente, Destino, Resto).


transbordo( Sitio1, Sitio2) :-
 horario( List),
 concatenar( _, [Sitio1,Sitio2|_ ], List).

diferencia( H1:Min1, H2:Min2, Diff) :-
 Diff is 60 * (H2 - H1) + Min2 - Min1.

es_antes(Hora1,Hora2):-
 diferencia(Hora1,Hora2,Diff), Diff>0.

list([]).
list([_|L]):-list(L).

concatenar([], L,L).
concatenar([X|L1], L2, [X|L3]):- concatenar(L1,L2,L3).
