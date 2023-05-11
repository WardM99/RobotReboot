:- module(map, [createMap/4]).

:- dynamic buren/2.



createMap(AantalRobots, Width, Height, [width(Width), height(Height)| Board]) :-
    createBoarder(Width, Height, BoarderBoard),
    placeDoel(Width,Height,BoarderBoard, BoardWithDoel),
    placeRobot0(BoardWithDoel,Width,Height,BoardWithRobot0),
    placeRobots(BoardWithRobot0,AantalRobots,Width,Height, 1, Board).

placeRobot0(Board, Width, Height, NewBoard) :-
    member(doel(Xdoel,Ydoel), Board),
    test(Board,6,0, Xdoel, Ydoel,Width, Height, [],Muren),
    append(Board, Muren, NewBoard).

test(_, 0, _,Xdoel, Ydoel, _,_,_,[robot(0,Xdoel, Ydoel)]) :-!. %stoppen
test(Bord,Aantal, PrevMove, Xdoel, Ydoel, Width, Height,NietGebruiken, [Muur|NextMuren]) :-
    getmove(PrevMove, Move),
    muurRondDoel(Xdoel, Ydoel, Move, Muur),
    getNextCordinat(Xdoel, Ydoel, Move, Width, Height, NietGebruiken,Xnext, Ynext),
    NewAantal is Aantal - 1,
    nieuweNietGebruiken(NietGebruiken,Xdoel, Ydoel, Xnext, Ynext, Move, NewNietGebruiken),
    test(Bord, NewAantal, Move, Xnext, Ynext, Width, Height, NewNietGebruiken, NextMuren).
test(Bord,_, _,Xdoel, Ydoel, _, _,_,[robot(0,Xrobot, Yrobot)]) :- % stoppen!
    \+member(doel(Xdoel, Ydoel), Bord),
    Xrobot is Xdoel,
    Yrobot is Ydoel.
test(Bord,_, _,Xdoel, Ydoel, Width, Height,_,[robot(0,Xrobot, Yrobot)]) :- % Als degene er voor faalt, gewoon een robot plaatsen op een willekeurige plaats. is alleen het doel tegen een muur is, en de eerste move gekozen is dat het niet meer beweegt
    member(doel(Xdoel, Ydoel), Bord),
    HeightPrev is Height - 1,
    WidthPrev is Width - 1,
    findall(
        co(X,Y),
        (
            between(0,WidthPrev,X),
            between(0,HeightPrev,Y),  
            \+member(doel(X,Y),Bord)  
        ),
        AllCoords
    ),
    random_member(co(Xrobot,Yrobot), AllCoords).

nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, _, Ynext, u, NewNietGebruiken) :-
    findall(
        co(Xdoel, Y),
        between(Ynext,Ydoel,Y),
        AllCoords
    ),
    write("u: "),
    write(AllCoords),nl,
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, _, Ynext, d, NewNietGebruiken) :-
    findall(
        co(Xdoel, Y),
        between(Ydoel,Ynext,Y),
        AllCoords
    ),
    write("d: "),
    write(AllCoords),nl,
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, Xnext, _, l, NewNietGebruiken) :-
    findall(
        co(X, Ydoel),
        between(Xnext,Xdoel,X),
        AllCoords
    ),
    write("l: "),
    write(AllCoords),nl,
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, Xnext, _, r, NewNietGebruiken) :-
    findall(
        co(X, Ydoel),
        between(Xdoel,Xnext,X),
        AllCoords
    ),
    write("r: "),
    write(AllCoords),nl,
    append(NietGebruiken, AllCoords, NewNietGebruiken).

nieuweNietGebruiken(NietGebruiken, _, _, _, _, _, NietGebruiken).

getNextCordinat(Xdoel, Ydoel, u, _, _, NietGebruiken, Xdoel, Yrand) :-
    YdoelPrev is Ydoel - 1,
    findall(
        co(Xdoel,Y), 
        (
            between(0, YdoelPrev, Y),
            \+member(co(Xdoel,Y), NietGebruiken)
        ),
        AllCoords  
    ),
    random_member(co(Xdoel, Yrand), AllCoords).

getNextCordinat(Xdoel,Ydoel, d, _, Height, NietGebruiken, Xdoel, Yrand) :-
    YdoelNext is Ydoel + 1,
    HeightPrev is Height - 1,
    findall(
        co(Xdoel,Y),
        (
            between(YdoelNext, HeightPrev, Y),
            \+member(co(Xdoel,Y), NietGebruiken)
        ),
        AllCoords
    ),
    random_member(co(Xdoel, Yrand), AllCoords).
getNextCordinat(Xdoel, Ydoel, l, _, _, NietGebruiken, Xrand, Ydoel) :-
    XdoelPrev is Xdoel - 1,
    findall(
        co(X,Ydoel), 
        (
            between(0, XdoelPrev, X),
            \+member(co(X,Ydoel), NietGebruiken)
        ),
        AllCoords
    ),
    random_member(co(Xrand, Ydoel), AllCoords).
getNextCordinat(Xdoel, Ydoel, r, Width, _, NietGebruiken, Xrand, Ydoel):-
    XdoelNext is Xdoel + 1,
    WidthPrev is Width - 1,
    findall(
        co(X,Ydoel),
        (
            between(XdoelNext, WidthPrev, X),
            \+member(co(X,Ydoel), NietGebruiken)
        ),
        AllCoords
    ),
    random_member(co(Xrand, Ydoel), AllCoords).

muurRondDoel(Xdoel, Ydoel, u, muur(Xdoel, Ynext,Xdoel, Ydoel)) :-
    Ynext is Ydoel + 1.
muurRondDoel(Xdoel, Ydoel, d, muur(Xdoel, Ydoel,Xdoel, Yprev)) :-
    Yprev is Ydoel - 1.
muurRondDoel(Xdoel, Ydoel, l, muur(Xnext, Ydoel,Xdoel, Ydoel)) :-
    Xnext is Xdoel + 1.
muurRondDoel(Xdoel, Ydoel, r, muur(Xdoel, Ydoel,Xprev, Ydoel)) :-
    Xprev is Xdoel - 1.

getmove(PreviousMove, NewMove) :-
    possiblemoves(PreviousMove, Moves),
    random_member(NewMove, Moves).

possiblemoves(l, [u,d]).
possiblemoves(r, [u,d]).
possiblemoves(d, [l,r]).
possiblemoves(u, [l,r]).
possiblemoves(0, [u,d,l,r]).

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
    pred(W,Xs),
    pred(H,Ys),
    findall(
        co(X1,Y1),
        (   
            member(X1,Xs),
            member(Y1,Ys)
        )
        ,AllFreePlaces
    ),
    random_member(co(X,Y),AllFreePlaces),!.

%inCorner(Board, X, Y) :-
%    PX is X - 1,
%    PY is Y - 1,
%    member(muur(X,Y,PX,Y),Board),
%    member(muur(X,Y,X,PY), Board).
%inCorner(Board,X,Y) :-
%    NX is X + 1,
%    PY is Y - 1,
%    member(muur(NX,Y,X,Y),Board),
%    member(muur(X,Y,X,PY),Board).
%inCorner(Board,X,Y) :-
%    PX is X - 1,
%    NY is Y + 1,
%    member(muur(X,NY,X,Y),Board),
%    member(muur(X,Y,PX,Y),Board).
%inCorner(Board,X,Y) :-
%    NX is X + 1,
%    NY is Y + 1,
%    member(muur(X,NY,X,Y),Board),
%    member(muur(NX,Y,X,Y),Board).

%noBoarderAroundCell(Board,X,Y) :-
%    NX is X+1, 
%    \+member(muur(NX,Y,X,Y),Board),
%    PX is X-1, 
%    \+member(muur(X,Y,PX,Y),Board),
%    NY is Y+1, 
%    \+member(muur(X,NY,X,Y),Board),
%    PY is Y-1,  
%    \+member(muur(X,Y,X,PY),Board).


    %(
    %    member(muur(X1,_,PX,_),Board);
    %    member(muur(NX,_,X1,_),Board);
    %    member(muur(_,Y1,_,PY),Board);
    %    member(muur(_,NY,_,Y1),Board)
    %)







%   NX is X1+1, 
%   NY is Y1+1, 
%   PX is X1-1, 
%   PY is Y1-1, 

placeRobots(B,AantalRobots, _, _, AantalRobots, B).
placeRobots(Board, AantalRobots, W, H, RobotIndex, [robot(RobotIndex,X,Y)|NewBoard]) :-
    NextRobot is RobotIndex + 1,
    placeRobots(Board, AantalRobots, W, H, NextRobot, NewBoard),
    getRandomPlace(NewBoard,W,H,X,Y).
    %append([robot(RobotIndex,X,Y)], NewBoard, BoardWithRobots).


%placeMuren(B,B).
placeMuren(Board, NextBoard) :-
    member(doel(X,Y), Board),
    findall(co(X1,Y1),member(muur(X1,Y1,X,Y),Board),NextMuren),
    findall(co(X1,Y1),member(muur(X,Y,X1,Y1),Board),PreviousMuren),
    append(NextMuren,PreviousMuren, MurenRondRobot),
    random(0,4,I),
    getMuren(MurenRondRobot,I,X,Y,MurenRobot),
    append(MurenRobot,Board, NextBoard).

placeOuterMuren(Bord, NewBoard, Width, Height) :-
    WidthMin1 is Width - 1,
    WidthMin2 is Width - 2,
    HeightMin1 is Height - 1,
    HeightMin2 is Height - 2,
    placeHorizontalMuren(0, 1, WidthMin1, TopMuren),
    placeHorizontalMuren(HeightMin1,0, WidthMin2, BottomMuren),
    append(TopMuren, BottomMuren, HorziontalMuren),
    placeVerticalMuren(0,0, HeightMin2, LeftMuren),
    placeVerticalMuren(WidthMin1,1, HeightMin1, RightMuren),
    append(LeftMuren, RightMuren, VertcialMuren),
    append(VertcialMuren, HorziontalMuren, BorderMuren),
    append(Bord, BorderMuren, NewBoard).

placeHorizontalMuren(_, X, Width, []) :-
    X >= Width,!.
placeHorizontalMuren(Y, X, Width, [muur(Xnext,Y,Xmuur,Y)|Hmuren]) :-
    random(X, Width, Xmuur),
    NextX is Xmuur + 2,
    placeHorizontalMuren(Y, NextX, Width, Hmuren),
    Xnext is Xmuur+1.

placeVerticalMuren(_, Y, Height, []) :-
    Y >= Height,!.
placeVerticalMuren(X, Y, Height, [muur(X, Ynext, X, Ymuur)|Vmuren]) :-
    random(Y, Height, Ymuur),
    NextY is Ymuur + 2,
    placeVerticalMuren(X, NextY, Height, Vmuren),
    Ynext is Ymuur + 1.


getMuren(MurenRondRobot, _,_,_, []) :-
    length(MurenRondRobot, L),
    L >= 2.
getMuren(MurenRondRobot, R, X,Y, [muur(X,Y,X,PY)]) :- % muur links & random is boven
    0 is R mod 2,
    PX is X - 1,
    member(co(PX,Y), MurenRondRobot),!,
    PY is Y - 1.
getMuren(MurenRondRobot, R, X,Y, [muur(X,NY,X,Y)]) :- % muur links & random is onder
    1 is R mod 2,
    PX is X - 1,
    member(co(PX,Y), MurenRondRobot),!,
    NY is Y + 1.

getMuren(MurenRondRobot, R, X,Y, [muur(X,Y,X,PY)]) :- % muur rechts & random is boven
    0 is R mod 2,
    NX is X + 1,
    member(co(NX,Y), MurenRondRobot),!,
    PY is Y - 1.
getMuren(MurenRondRobot, R, X,Y, [muur(X,NY,X,Y)]) :- % muur rechts & random is onder
    1 is R mod 2,
    NX is X + 1,
    member(co(NX,Y), MurenRondRobot),!,
    NY is Y + 1.

getMuren(MurenRondRobot, R, X,Y, [muur(X,Y,PX,Y)]) :- % muur boven & random is links
    0 is R mod 2,
    PY is Y - 1,
    member(co(X,PY), MurenRondRobot),!,
    PX is X - 1.
getMuren(MurenRondRobot, R, X,Y, [muur(NX,Y,X,Y)]) :- % muur boven & random is rechts
    1 is R mod 2,
    PY is Y - 1,
    member(co(X,PY), MurenRondRobot),!,
    NX is X + 1.

getMuren(MurenRondRobot, R, X,Y, [muur(X,Y,PX,Y)]) :- % muur onder & random is links
    0 is R mod 2,
    NY is Y + 1,
    member(co(X,NY), MurenRondRobot),!,
    PX is X - 1.
getMuren(MurenRondRobot, R, X,Y, [muur(NX,Y,X,Y)]) :- % muur onder & random is rechts
    1 is R mod 2,
    NY is Y + 1,
    member(co(X,NY), MurenRondRobot),!,
    NX is X + 1.

getMuren(MurenRondRobot,0,X,Y,[muur(X,Y,PX,Y),muur(X,Y,X,PY)]) :- % links boven
    length(MurenRondRobot, L),
    L is 0,!,
    PX is X - 1,
    PY is Y - 1.
getMuren(MurenRondRobot,1,X,Y,[muur(NX,Y,X,Y),muur(X,Y,X,PY)]) :- % rechtsboven
    length(MurenRondRobot, L),
    L is 0,!,
    NX is X + 1,
    PY is Y - 1.
getMuren(MurenRondRobot,2,X,Y,[muur(NX,Y,X,Y),muur(X,NY,X,Y)]) :- % rechtsonder
    length(MurenRondRobot, L),
    L is 0,!,
    NX is X + 1,
    NY is Y + 1.
getMuren(MurenRondRobot,3,X,Y,[muur(X,Y,PX,Y),muur(X,NY,X,Y)]) :- % linksonder
    length(MurenRondRobot, L),
    L is 0,!,
    PX is X - 1,
    NY is Y + 1.

getRandomPlace(CurrentRobots,W,H,X,Y):-
    findall(
        co(X1,Y1),
        (   
            pred(W,Xs),
            pred(H,Ys),
            member(X1,Xs),
            member(Y1,Ys),
            \+member(robot(_,X1,Y1),CurrentRobots),
            \+member(doel(X1,Y1),CurrentRobots)
        )
        ,AllFreePlaces
    ),
    length(AllFreePlaces,L),
    random(0,L,I),
    nth0(I, AllFreePlaces, co(X,Y)).

pred(1, [0]):-!.
pred(N, [N1|T]) :-
    N1 is N-1,
    pred(N1, T).