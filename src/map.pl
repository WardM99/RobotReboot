:- module(map, [createMap/4]).

:- use_module(print).
:- dynamic buren/2.


% het map maken volgens de stappen
createMap(AantalRobots, Width, Height, [width(Width), height(Height)| Board]) :-
    createBoarder(Width, Height, BoarderBoard),
    placeDoel(Width,Height,BoarderBoard, BoardWithDoel),
    placeRobot0(BoardWithDoel,Width,Height,BoardWithRobot0,NietGebruiken),
    placeExtraMuren(BoardWithRobot0, NietGebruiken, Width, Height, BoardWithMuren),
    placeRobots(BoardWithMuren,AantalRobots,Width,Height, 1, Board).

% Muren plaatsen dat niet in het pad zitten
placeExtraMuren(Bord, NietGebruiken, Width, Height, BoardWithMuren) :-
    WidthPrev is Width - 1,
    HeightPrev is Height - 1,
    findall(
        co(X,Y),
        (
            between(0,WidthPrev, X),
            between(0, HeightPrev, Y),
            \+member(co(X,Y),NietGebruiken)    
        ),
        AllCoords
    ),
    random(0,10,R),
    coordsToMuren(AllCoords,R,Muren),
    append(Bord,Muren,BoardWithMuren).

% van coördinaten overgaan naar muren
coordsToMuren([],_,[]).
coordsToMuren([co(X,Y)|T], 0, [muur(X,Y,Xprev,Y)|Muren]) :-
    Xprev is X - 1,
    random(0,10, R),
    coordsToMuren(T, R, Muren).
coordsToMuren([co(X,Y)|T], 1, [muur(Xnext,Y,X,Y)|Muren]) :-
    Xnext is X + 1,
    random(0,10, R),
    coordsToMuren(T, R, Muren).
coordsToMuren([co(X,Y)|T], 2, [muur(X,Y,X,Yprev)|Muren]) :-
    Yprev is Y - 1,
    random(0,10, R),
    coordsToMuren(T, R, Muren).
coordsToMuren([co(X,Y)|T], 3, [muur(X,Ynext,X,Y)|Muren]) :-
    Ynext is Y + 1,
    random(0,10, R),
    coordsToMuren(T, R, Muren).
coordsToMuren([_|T], _, Muren) :-
    random(0,10, R),
    coordsToMuren(T, R, Muren).

% het stappen voor het bepalen van de startpositie van robot0
placeRobot0(Board, Width, Height, NewBoard,NietGebruiken) :-
    member(doel(Xdoel,Ydoel), Board),
    getStartPostitionRobot0(Board,3,0, Xdoel, Ydoel,Width, Height, [],Muren,NietGebruiken),
    append(Board, Muren, NewBoard).

% het algoritme voor de startpositie van robot0 te bepalen
getStartPostitionRobot0(_, 0, _,Xdoel, Ydoel, _,_,NietGebruiken,[robot(0,Xdoel, Ydoel)],NietGebruiken) :-!. % stoppen, de bewegingen zijn op!
getStartPostitionRobot0(Bord,Aantal, PrevMove, Xdoel, Ydoel, Width, Height,NietGebruiken, [Muur|NextMuren],NietGebruikenTotaal) :-
    getmove(PrevMove, Move),
    muurRondDoel(Xdoel, Ydoel, Move, Muur),
    getNextCordinat(Xdoel, Ydoel, Move, Width, Height, NietGebruiken,Xnext, Ynext),
    NewAantal is Aantal - 1,
    nieuweNietGebruiken(NietGebruiken,Xdoel, Ydoel, Xnext, Ynext, Move, NewNietGebruiken),
    getStartPostitionRobot0(Bord, NewAantal, Move, Xnext, Ynext, Width, Height, NewNietGebruiken, NextMuren, NietGebruikenTotaal).
getStartPostitionRobot0(Bord,_, _,Xdoel, Ydoel, _, _,NietGebruiken,[robot(0,Xrobot, Yrobot)],NietGebruiken) :- % stoppen, kan niet meer bewegen!
    \+member(doel(Xdoel, Ydoel), Bord),
    Xrobot is Xdoel,
    Yrobot is Ydoel.
getStartPostitionRobot0(Bord,Aantal, PrevMove,Xdoel, Ydoel, Width, Height,NietGebruiken,[Muur|NextMuren],NietGebruikenTotaal) :- % gebeurt alleen het doel tegen een muur is, en de eerste move gekozen is dat het niet meer beweegt
    member(doel(Xdoel, Ydoel), Bord),
    possiblemoves(PrevMove, Moves),
    findall(
        RMove,
        (
            member(RMove, Moves),
            getNextCordinat(Xdoel, Ydoel, RMove, Width, Height, NietGebruiken, _,_)
        ),
        GoodMoves
    ),
    random_member(Move, GoodMoves),
    muurRondDoel(Xdoel, Ydoel, Move, Muur),
    getNextCordinat(Xdoel, Ydoel, Move, Width, Height, NietGebruiken,Xnext, Ynext),
    NewAantal is Aantal - 1,
    nieuweNietGebruiken(NietGebruiken,Xdoel, Ydoel, Xnext, Ynext, Move, NewNietGebruiken),
    getStartPostitionRobot0(Bord, NewAantal, Move, Xnext, Ynext, Width, Height, NewNietGebruiken, NextMuren, NietGebruikenTotaal).

% Coördinaten toevoegen aan een lijst dat niet meer mag gebruikt worden
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, _, Ynext, u, NewNietGebruiken) :-
    findall(
        co(Xdoel, Y),
        between(Ynext,Ydoel,Y),
        AllCoords
    ),
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, _, Ynext, d, NewNietGebruiken) :-
    findall(
        co(Xdoel, Y),
        between(Ydoel,Ynext,Y),
        AllCoords
    ),
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, Xnext, _, l, NewNietGebruiken) :-
    findall(
        co(X, Ydoel),
        between(Xnext,Xdoel,X),
        AllCoords
    ),
    append(NietGebruiken, AllCoords, NewNietGebruiken).
nieuweNietGebruiken(NietGebruiken, Xdoel, Ydoel, Xnext, _, r, NewNietGebruiken) :-
    findall(
        co(X, Ydoel),
        between(Xdoel,Xnext,X),
        AllCoords
    ),
    append(NietGebruiken, AllCoords, NewNietGebruiken).

nieuweNietGebruiken(NietGebruiken, _, _, _, _, _, NietGebruiken).

% Het volgende coördinaat bepalen voor het algoritme
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

% een muur plaatsen in de tegensgestelde richting van een doel coördinaat
muurRondDoel(Xdoel, Ydoel, u, muur(Xdoel, Ynext,Xdoel, Ydoel)) :-
    Ynext is Ydoel + 1.
muurRondDoel(Xdoel, Ydoel, d, muur(Xdoel, Ydoel,Xdoel, Yprev)) :-
    Yprev is Ydoel - 1.
muurRondDoel(Xdoel, Ydoel, l, muur(Xnext, Ydoel,Xdoel, Ydoel)) :-
    Xnext is Xdoel + 1.
muurRondDoel(Xdoel, Ydoel, r, muur(Xdoel, Ydoel,Xprev, Ydoel)) :-
    Xprev is Xdoel - 1.

% een nieuwe random richting krijgen
getmove(PreviousMove, NewMove) :-
    possiblemoves(PreviousMove, Moves),
    random_member(NewMove, Moves).

% de mogelijke zetten na een zet
possiblemoves(l, [u,d]).
possiblemoves(r, [u,d]).
possiblemoves(d, [l,r]).
possiblemoves(u, [l,r]).
possiblemoves(0, [u,d,l,r]).

% het maken van een rand rond het bord
createBoarder(Width, Height, Board) :-
    createHorizontalBoarder(Width, 0, 0, UpperBoarderBoard),!,
    createHorizontalBoarder(Width, Height, 0, LowerBoarderBoard),!,
    append(UpperBoarderBoard, LowerBoarderBoard, HoriontalBoarders),
    createVerticalBoarder(Height,0,0,LeftBoarderBoard),!,
    createVerticalBoarder(Height,0,Width, RightBoarderBoard),!,
    append(LeftBoarderBoard,RightBoarderBoard,VerticalBoarders),
    append(HoriontalBoarders,VerticalBoarders, Board).

% de horizontale randen maken
createHorizontalBoarder(Width, Y, Xlimit, [muur(Xlimit,Y,Xlimit,PY)]) :-
    Xlimit is Width - 1,
    PY is Y - 1.
createHorizontalBoarder(Width, Y, X, Board) :-
    NX is X + 1,
    PY is Y - 1,
    createHorizontalBoarder(Width, Y, NX, NextBoard),!,
    append([muur(X,Y,X,PY)], NextBoard, Board).

% de verticale randen maken
createVerticalBoarder(Height, Ylimit, X, [muur(X, Ylimit, PX, Ylimit)]) :-
    Ylimit is Height - 1,
    PX is X - 1.
createVerticalBoarder(Height, Y, X, Board) :-
    PX is X - 1,
    NY is Y + 1,
    createVerticalBoarder(Height, NY, X, NextBoard),!,
    append([muur(X,Y,PX,Y)], NextBoard, Board).

% een doel plaatsen op een random locatie
placeDoel(W, H, Board, [(doel(X,Y))|Board]) :-
    listOfNnumbers(W,Xs),
    listOfNnumbers(H,Ys),
    findall(
        co(X1,Y1),
        (   
            member(X1,Xs),
            member(Y1,Ys)
        )
        ,AllFreePlaces
    ),
    random_member(co(X,Y),AllFreePlaces),!.

% de andere robots plaatsen op random locaties
placeRobots(B,AantalRobots, _, _, AantalRobots, B).
placeRobots(Board, AantalRobots, W, H, RobotIndex, [robot(RobotIndex,X,Y)|NewBoard]) :-
    NextRobot is RobotIndex + 1,
    placeRobots(Board, AantalRobots, W, H, NextRobot, NewBoard),
    getRandomPlace(NewBoard,W,H,X,Y).

% een random plaats krijgen waar nog geen andere opvulling staat buiten leeg
getRandomPlace(CurrentRobots,W,H,X,Y):-
    findall(
        co(X1,Y1),
        (   
            listOfNnumbers(W,Xs),
            listOfNnumbers(H,Ys),
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

% een lijst krijgen van N tot 1.
listOfNnumbers(1, [0]):-!.
listOfNnumbers(N, [N1|T]) :-
    N1 is N-1,
    listOfNnumbers(N1, T).