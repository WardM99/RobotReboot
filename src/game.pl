:- module(game, [zet/4, solve/2,currentBoardSolved/1]).
:- use_module(library(clpfd)).

:- dynamic visited/1.
:- dynamic pairs/1.

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

replace(Board, Robot, OldX, OldY, NewX, NewY, [robot(Robot, NewX, NewY)|Board2]) :-
    select(robot(Robot, OldX, OldY), Board, Board2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allMoves((Board,CurrentMoves), Boards) :-
    %findall(Move, posibleMove(Move), Moves),
    pairs(Pairs),
    moves((Board,CurrentMoves), Pairs, Boards).

moves((_,_), [], []).
moves((Board,Moves), [(R,M)|Tail], [(NewBoard,[(R,M)|Moves])|NextBoards]) :-
    zet(Board, R, M, NewBoard),
    moves((Board,Moves),Tail, NextBoards).

solve(CurrentBoard, SolveMoves) :-
    findall(Robot, member(robot(Robot,_,_), CurrentBoard), Robots),
    sort(Robots,RobotsSorted),
    findall((R,M), (member(M, [l,r,u,d]), member(R, RobotsSorted)), Pairs),
    assert(pairs(Pairs)),
    allMoves((CurrentBoard, []), [Next|T]),
    solve(Next, T, SolveMoves).

solve((CurrentBoard,SolveMoves), _, SolveMoves) :-
    currentBoardSolved(CurrentBoard),!.
solve((CurrentBoard,Moves), [Next|T], SolveMoves) :-
    boardOnlyRobots(CurrentBoard, String),
    \+visited(String),!,
    %length(Moves, L),write(L),nl,
    assert(visited(String)),
    appendAllMoves(CurrentBoard, Moves, T, NextBoards),!,
    solve(Next,NextBoards, SolveMoves).
solve((_,_), [Next|T], SolveMoves) :-
    !,solve(Next,T, SolveMoves).

currentBoardSolved(Board) :-
    member(robot(0,X,Y), Board),
    member(doel(X,Y), Board),!.

appendAllMoves(CurrentBoard, Moves,T, NextBoards):-
    allMoves((CurrentBoard, Moves), Boards),
    append(T, Boards, NextBoards).


boardOnlyRobots(Board, OnlyRobots) :-
    findall(robot(R,X,Y), (member(robot(R,X,Y),Board)),OnlyRobotsUnstorted),
    sort(OnlyRobotsUnstorted, OnlyRobots).