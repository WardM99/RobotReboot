:- module(game, [zet/4, solve/2,currentBoardSolved/1]).

:- dynamic visited/1.
:- dynamic pairs/1.

% Gegeven een bord, een robot en een zet, wat is het nieuwe bord
zet(Board, Robot, d, NewBoard) :-
    memberchk(robot(Robot, X,Y), Board),
    down(Board, X, Y, NewY),
    replace(Board, Robot, X, Y, X, NewY, NewBoard),!.
zet(Board, Robot, u, NewBoard) :-
    memberchk(robot(Robot, X,Y), Board),
    up(Board, X, Y, NewY),
    replace(Board, Robot, X, Y, X, NewY, NewBoard),!.
zet(Board, Robot, l, NewBoard) :-
    memberchk(robot(Robot, X,Y), Board),
    left(Board, X, Y, NewX),
    replace(Board, Robot, X, Y, NewX, Y, NewBoard),!.
zet(Board, Robot, r, NewBoard) :-
    memberchk(robot(Robot, X,Y), Board),
    right(Board, X, Y, NewX),
    replace(Board, Robot, X, Y, NewX, Y, NewBoard),!.

% bepalen van de nieuwe coördinaat voor naar beneden te gaan
down(Board, X,Y,Y) :-
    NY is Y + 1,
    memberchk(muur(X,NY,X,Y), Board).
down(Board, X,Y,Y) :-
    NY is Y + 1,
    memberchk(robot(_,X,NY), Board).
down(Board, X, Y, NewY) :-
    NY is Y + 1,
    down(Board, X, NY, NewY).

% bepalen van de nieuwe coördinaat voor naar omhoog te gaan
up(Board, X,Y,Y) :-
    PY is Y - 1,
    memberchk(muur(X,Y,X,PY), Board).
up(Board, X,Y,Y) :-
    PY is Y - 1,
    memberchk(robot(_, X, PY), Board).
up(Board, X, Y, NewY) :-
    PY is Y - 1,
    up(Board, X, PY, NewY).

% bepalen van de nieuwe coördinaat voor naar links te gaan
left(Board, X, Y, X) :-
    PX is X - 1,
    memberchk(muur(X,Y,PX,Y), Board).
left(Board, X, Y, X) :-
    PX is X - 1,
    memberchk(robot(_, PX, Y), Board).
left(Board, X, Y, NewX) :-
    PX is X - 1,
    left(Board, PX, Y, NewX).

% bepalen van de nieuwe coördinaat voor naar rechts te gaan
right(Board, X, Y, X) :-
    NX is X + 1,
    memberchk(muur(NX,Y,X,Y), Board).
right(Board, X, Y, X) :-
    NX is X + 1,
    memberchk(robot(_, NX, Y), Board).
right(Board, X, Y, NewX) :-
    NX is X + 1,
    right(Board, NX, Y, NewX).

% de oude robot vervangen met de nieuwe coördinaten
replace(Board, Robot, OldX, OldY, NewX, NewY, [robot(Robot, NewX, NewY)|Board2]) :-
    selectchk(robot(Robot, OldX, OldY), Board, Board2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% alle zetten bepalen van een bord
allMoves((Board,CurrentMoves), Boards) :-
    pairs(Pairs),
    moves((Board,CurrentMoves), Pairs, Boards).

% alle zetten toepassen op een bord
moves((_,_), [], []).
moves((Board,Moves), [(R,M)|Tail], [(NewBoard,[(R,M)|Moves])|NextBoards]) :-
    zet(Board, R, M, NewBoard),
    moves((Board,Moves),Tail, NextBoards).

% een optimale oplossing verkrijgen van een bord
solve(CurrentBoard, SolveMoves) :-
    findall(Robot, member(robot(Robot,_,_), CurrentBoard), Robots),
    sort(Robots,RobotsSorted),
    findall((R,M), (member(M, [l,r,u,d]), member(R, RobotsSorted)), Pairs),
    assert(pairs(Pairs)),
    allMoves((CurrentBoard, []), [Next|T]),
    solve(Next, T, SolveMoves),!.

% een optimale oplossing verkrijgen van een bord, met de andere borden in de wachtrij
solve((CurrentBoard,SolveMoves), _, SolveMoves) :-
    currentBoardSolved(CurrentBoard),!.
solve((CurrentBoard,Moves), [Next|T], SolveMoves) :-
    boardOnlyRobots(CurrentBoard, String),
    \+visited(String),!,
    assert(visited(String)),
    appendAllMoves(CurrentBoard, Moves, T, NextBoards),!,
    solve(Next,NextBoards, SolveMoves).
solve((_,_), [Next|T], SolveMoves) :-
    !,solve(Next,T, SolveMoves).

% kijken of het huidige bord opgelost is
currentBoardSolved(Board) :-
    memberchk(robot(0,X,Y), Board),
    memberchk(doel(X,Y), Board),!.

% alle zetten toevoegen aan een lijst
appendAllMoves(CurrentBoard, Moves,T, NextBoards):-
    allMoves((CurrentBoard, Moves), Boards),
    append(T, Boards, NextBoards).

% een gesorteerde lijst op index van de robots voor te vergelijken of een bord hetzelfde is
boardOnlyRobots(Board, OnlyRobots) :-
    findall(robot(R,X,Y), (member(robot(R,X,Y),Board)),OnlyRobotsUnstorted),
    sort(OnlyRobotsUnstorted, OnlyRobots).