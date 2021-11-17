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