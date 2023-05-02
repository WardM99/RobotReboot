:- module(map, [createMap/4]).

createMap(AantalRobots, Width, Height, Board) :-
    createBoarder(Width, Height, BoarderBoard),
    createWalls(Width, Height, 0, 0, WallBoard),
    append(BoarderBoard, WallBoard, WallsBoard),
    placeDoel(Width, Height, WallsBoard, BoardWithDoel),
    placeRobots(AantalRobots,Width,Height, 0, Robots),
    append([height(Height),width(Width)|Robots], BoardWithDoel, Board).

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

createWalls(Width, Height, X, Y, []) :- % rechter onder hoek, mag geen exta muren toevoegen
    X is Width - 1,
    Y is Height - 1,!.
createWalls(Width, Height, X, Y, WallBoard) :- % laatste rij, alleen verticaal toevoegen
    Y is Height - 1,
    NX is X + 1,
    createWalls(Width, Height, NX, Y, NextWallBoard),!,
    random(0,6,R),
    makeVerticalWall(X,Y,R,VW),
    append(VW, NextWallBoard, WallBoard).
createWalls(Width, Height, X, Y, WallBoard) :- % laatste kolom, alleen horizontaal toevoegen
    X is Width - 1,
    NY is Y + 1,
    createWalls(Width, Height, 0, NY, NextWallBoard),!,
    random(0,6,R),
    makeHorintalWall(X,Y,R,HW),
    append(HW, NextWallBoard, WallBoard).
createWalls(Width, Height, X, Y, WallBoard) :- % de rest, horzintaal als verticaal toevoegen
    NX is X + 1,
    createWalls(Width, Height, NX, Y, NextWallBoard),!,
    random(0,6,R1),
    random(0,6,R2),
    makeHorintalWall(X,Y,R1,HW),
    makeVerticalWall(X,Y,R2,VW),
    append(HW, VW, Walls),
    append(Walls, NextWallBoard, WallBoard).

makeHorintalWall(X,Y,1,[muur(X,NY,X,Y)]) :-
    NY is Y + 1.
makeHorintalWall(_,_,_,[]).

makeVerticalWall(X,Y,1,[muur(NX,Y,X,Y)]) :-
    NX is X + 1.
makeVerticalWall(_,_,_,[]).

placeDoel(W, H, Board, [(doel(X,Y))|Board]) :-
    random(0,W,X),
    random(0,H,Y).

placeRobots(AantalRobots, _, _, AantalRobots, []).
placeRobots(AantalRobots, W, H, RobotIndex, BoardWithRobots) :-
    random(0,W,X),
    random(0,H,Y),
    NextRobot is RobotIndex + 1,
    placeRobots(AantalRobots, W, H, NextRobot, NewBoard),
    append([robot(RobotIndex,X,Y)], NewBoard, BoardWithRobots).