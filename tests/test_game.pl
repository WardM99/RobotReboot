:- begin_tests(game).
:- load_files('../src/game.pl', [import(all)]).

startBord([muur(0,0,0,-1),muur(1,0,1,-1),muur(2,0,2,-1),muur(3,0,3,-1),width(4),muur(0,0,-1,0),robot(1,0,0),muur(2,0,1,0),muur(4,0,3,0),muur(3,1,3,0),muur(0,1,-1,1),robot(0,2,1),muur(4,1,3,1),muur(1,2,1,1),muur(0,2,-1,2),doel(1,2),muur(2,2,1,2),muur(4,2,3,2),muur(0,3,-1,3),muur(1,3,0,3),muur(4,3,3,3),muur(0,4,0,3),muur(1,4,1,3),muur(2,4,2,3),muur(3,4,3,3),height(4)]).

test(zetDownRobot0) :-
    startBord(B),
    zet(B,0,d,BoardZet),
    member(robot(0,2,3), BoardZet),!.

test(zetDownInDeWegRobot0) :-
    startBord(B),
    zet([robot(9,2,2)|B],0,d,BoardZet),
    \+member(robot(0,2,3), BoardZet),!,
    member(robot(0,2,1), BoardZet),!.

test(zetDownRobot1) :-
    startBord(B),
    zet(B,1,d,BoardZet),
    \+member(robot(0,2,3), BoardZet),!,
    member(robot(1,0,3), BoardZet),!.

test(zetUpRobot0) :-
    startBord(B),
    zet(B,0,u,BoardZet),
    member(robot(0,2,0), BoardZet),!.

test(zetUpInDeWegRobot0) :-
    startBord(B),
    zet([robot(9,2,0)|B],0,u,BoardZet),
    \+member(robot(0,2,0), BoardZet),!,
    member(robot(0,2,1), BoardZet),!.

test(zetUpRobot1) :-
    startBord(B),
    zet(B,1,u,BoardZet),
    \+member(robot(0,2,0), BoardZet),!,
    member(robot(1,0,0), BoardZet),!.

test(zetLeftRobot0) :-
    startBord(B),
    zet(B,0,l,BoardZet),
    member(robot(0,0,1), BoardZet),!.

test(zetLeftInDeWegRobot0) :-
    startBord(B),
    zet([robot(9,1,1)|B],0,l,BoardZet),
    \+member(robot(0,0,1), BoardZet),!,
    member(robot(0,2,1), BoardZet),!.

test(zetLeftRobot1) :-
    startBord(B),
    zet(B,1,l,BoardZet),
    \+member(robot(0,0,1), BoardZet),!,
    member(robot(1,0,0), BoardZet),!.

test(zetRightRobot0) :-
    startBord(B),
    zet(B,0,r,BoardZet),
    member(robot(0,3,1), BoardZet),!.

test(zetRightInDeWegRobot0) :-
    startBord(B),
    zet([robot(9,3,1)|B],0,r,BoardZet),
    \+member(robot(0,3,1), BoardZet),!,
    member(robot(0,2,1), BoardZet),!.

test(zetRightRobot1) :-
    startBord(B),
    zet(B,1,r,BoardZet),
    \+member(robot(0,3,1), BoardZet),!,
    member(robot(1,1,0), BoardZet),!.

test(currentBoardNotSolvedStartBoard) :-
    startBord(B),
    \+currentBoardSolved(B).

test(currentBoardNotSolvedOtherRobotOnDoel) :-
    startBord(B),
    \+currentBoardSolved([robot(9,1,2)|B]).

test(currentBoardSolved) :-
    startBord(B),
    zet(B,0,d,Temp1),
    zet(Temp1,0,l,Temp2),
    zet(Temp2,0,u,Solved),
    currentBoardSolved(Solved).

test(solve) :-
    startBord(B),
    solve(B, [(0,u),(0,l),(0,d)]).

:- end_tests(game).
