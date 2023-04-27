:- module(game, [zet/4, solve/2]).

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
down(Board, X,Y,Y) :-
    NY is Y + 1,
    member(robot(_,X,NY), Board).
down(Board, X, Y, NewY) :-
    NY is Y + 1,
    down(Board, X, NY, NewY).

up(Board, X,Y,Y) :-
    PY is Y - 1,
    member(muur(X,Y,X,PY), Board).
up(Board, X,Y,Y) :-
    PY is Y - 1,
    member(robot(_, X, PY), Board).
up(Board, X, Y, NewY) :-
    PY is Y - 1,
    up(Board, X, PY, NewY).

left(Board, X, Y, X) :-
    PX is X - 1,
    member(muur(X,Y,PX,Y), Board).
left(Board, X, Y, X) :-
    PX is X - 1,
    member(robot(_, PX, Y), Board).
left(Board, X, Y, NewX) :-
    PX is X - 1,
    left(Board, PX, Y, NewX).

right(Board, X, Y, X) :-
    NX is X + 1,
    member(muur(NX,Y,X,Y), Board).
right(Board, X, Y, X) :-
    NX is X + 1,
    member(robot(_, NX, Y), Board).
right(Board, X, Y, NewX) :-
    NX is X + 1,
    right(Board, NX, Y, NewX).

replace(Board, Robot, OldX, OldY, NewX, NewY, NewBoard) :-
    select(robot(Robot, OldX, OldY), Board, Board2),
    append([robot(Robot, NewX, NewY)], Board2, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
posibleMove(l).
posibleMove(r).
posibleMove(u).
posibleMove(d).

allMoves(Board, Boards) :-
    findall(Move, posibleMove(Move), Moves),
    findall(Robot, member(robot(Robot,_,_), Board), Robots),
    findall((R,M), (member(M, Moves), member(R, Robots)), Pairs),
    moves(Board, Pairs, Boards).

moves(_, [], []).
moves(Board, [(R,M)|Tail], Boards) :-
    zet(Board, R, M, NewBoard),
    moves(Board,Tail, NextBoards),
    select(moves(CurrentMoves), NewBoard, NewBoard2),
    append([moves([(R,M)|CurrentMoves])], NewBoard2, NewBoard3),
    append([NewBoard3], NextBoards, Boards).

solve(CurrentBoard, SolveMoves) :-
    allMoves(CurrentBoard, [Next|T]),
    solve(Next, T, SolveMoves).

solve(CurrentBoard, _, SolveMoves) :-
    currentBoardSolved(CurrentBoard),
    member(moves(SolveMoves), CurrentBoard).

solve(CurrentBoard, [Next|T], SolveMoves) :-
    \+currentBoardSolved(CurrentBoard),
    allMoves(CurrentBoard, Boards),
    append(T, Boards, NextBoards),!,
    solve(Next,NextBoards, SolveMoves).

currentBoardSolved(Board) :-
    member(robot(0,X,Y), Board),
    member(doel(X,Y), Board).