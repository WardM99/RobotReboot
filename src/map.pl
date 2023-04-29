:- module(map, [createMap/4]).

createMap(_, Width, Height, Board) :-
    createBoarder(Width, Height, BoarderBoard),
    createWalls(Width, Height, 0, 0, WallBoard),
    append(BoarderBoard, WallBoard, WallsBoard),
    append([height(Height),width(Width)], WallsBoard, Board).

createBoarder(Width, Height, Board) :-
    createHorizontalBoarder(Width, 0, 0, UpperBoarderBoard),!,
    createHorizontalBoarder(Width, Height, 0, LowerBoarderBoard),!,
    append(UpperBoarderBoard, LowerBoarderBoard, HoriontalBoarders),
    createVerticalBoarder(Height,0,0,LeftBoarderBoard),!,
    createVerticalBoarder(Height,0,Width, RightBoarderBoard),!,
    append(LeftBoarderBoard,RightBoarderBoard,VerticalBoarders),
    append(HoriontalBoarders,VerticalBoarders, Board).


createHorizontalBoarder(Width, Y, Xlimit, [muur(Xlimit,Y,Xlimit,PY)]) :-
    Xlimit is Width - 1,
    PY is Y - 1.
createHorizontalBoarder(Width, Y, X, Board) :-
    NX is X + 1,
    PY is Y - 1,
    createHorizontalBoarder(Width, Y, NX, NextBoard),!,
    append([muur(X,Y,X,PY)], NextBoard, Board).
createVerticalBoarder(Height, Ylimit, X, [muur(X, Ylimit, PX, Ylimit)]) :-
    Ylimit is Height - 1,
    PX is X - 1.
createVerticalBoarder(Height, Y, X, Board) :-
    PX is X - 1,
    NY is Y + 1,
    createVerticalBoarder(Height, NY, X, NextBoard),!,
    append([muur(X,Y,PX,Y)], NextBoard, Board).

createWalls(Width, Height, Width, Ylimit, []) :-
    Ylimit is Height - 1.
createWalls(Width, Height, X, Y, Board) :-
    NX is X + 1,
    NY is Y + 1,
    createWalls(Width, Height,NX,Y,NextBoard),
    append([muur(NX,Y,X,Y),muur(X,NY,X,Y)], NextBoard, Board).