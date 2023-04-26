:- module(game, [zet/4]).

zet(Board, Robot, d, NewBoard) :-
    member(robot(Robot, X,Y), Board),
    down(Board, X, Y, NewY),
    replace(Board, Robot, X, Y, X, NewY, NewBoard).
zet(Board, Robot, u, NewBoard) :-
    member(robot(Robot, X,Y), Board),
    up(Board, X, Y, NewY),
    replace(Board, Robot, X, Y, X, NewY, NewBoard).
zet(Board, Robot, l, NewBoard) :-
    member(robot(Robot, X,Y), Board),
    left(Board, X, Y, NewX),
    replace(Board, Robot, X, Y, NewX, Y, NewBoard).
zet(Board, Robot, r, NewBoard) :-
    member(robot(Robot, X,Y), Board),
    right(Board, X, Y, NewX),
    replace(Board, Robot, X, Y, NewX, Y, NewBoard).

down(Board, X,Y,Y) :-
    NY is Y + 1,
    member(muur(X,NY,X,Y), Board).
down(Board, X, Y, NewY) :-
    NY is Y + 1,
    \+member(muur(X,NY,X,Y), Board),
    down(Board, X, NY, NewY).

up(Board, X,Y,Y) :-
    PY is Y - 1,
    member(muur(X,Y,X,PY), Board).
up(Board, X, Y, NewY) :-
    PY is Y - 1,
    \+member(muur(X,Y,X,PY), Board),
    up(Board, X, PY, NewY).

left(Board, X, Y, X) :-
    PX is X - 1,
    member(muur(X,Y,PX,Y), Board).
left(Board, X, Y, NewX) :-
    PX is X - 1,
    \+member(muur(X,Y,PX,Y), Board),
    left(Board, PX, Y, NewX).

right(Board, X, Y, X) :-
    NX is X + 1,
    member(muur(NX,Y,X,Y), Board).
right(Board, X, Y, NewX) :-
    NX is X + 1,
    \+member(muur(NX,Y,X,Y), Board),
    right(Board, NX, Y, NewX).

replace(Board, Robot, OldX, OldY, NewX, NewY, NewBoard) :-
    select(robot(Robot, OldX, OldY), Board, Board2),
    append([robot(Robot, NewX, NewY)], Board2, NewBoard).