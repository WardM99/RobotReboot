:- initialization(main, main).
:- use_module(animate).
:- use_module(print).
:- use_module(parser).
:- use_module(game).
:- use_module(map).



%!  next_world(?X:int, +I:string, -Y:int) is det
%!  next_world(+X:int, ?I:string, -Y:int) is det
%   
%   Based on the current world and command-line input, outputs the new world.

next_world([], 10, []) :- 
    clear(Clear),
    format("~w", [Clear]),
    halt(0).
next_world([], _, []).
next_world(_, 0, _) :- 
    clear(Clear),
    format("~w", [Clear]),
    halt(0).
next_world(X, 1, Y) :- 
    member(currentRobot(IndexRobot), X),
    findall(I,(member(robot(I,_,_),X)),AllRobots),
    sort(AllRobots,RobotsSorted),
    nth0(IndexRobot, RobotsSorted, R),
    zet(X,R,u,Board),
    checkSolved(Board,Y).
next_world(X, 2, Y) :- 
    member(currentRobot(IndexRobot), X),
    findall(I,(member(robot(I,_,_),X)),AllRobots),
    sort(AllRobots,RobotsSorted),
    nth0(IndexRobot, RobotsSorted, R),
    zet(X,R,d,Board),
    checkSolved(Board,Y).
next_world(X, 3, Y) :- 
    member(currentRobot(IndexRobot), X),
    findall(I,(member(robot(I,_,_),X)),AllRobots),
    sort(AllRobots,RobotsSorted),
    nth0(IndexRobot, RobotsSorted, R),
    zet(X,R,l,Board),
    checkSolved(Board,Y).
next_world(X, 4, Y) :- 
    member(currentRobot(IndexRobot), X),
    findall(I,(member(robot(I,_,_),X)),AllRobots),
    sort(AllRobots,RobotsSorted),
    nth0(IndexRobot, RobotsSorted, R),
    zet(X,R,r,Board),
    checkSolved(Board,Y).
next_world(X, 5, [currentRobot(NextRobot)|Board]) :- 
    select(currentRobot(R), X, Board),
    PossibleNextRobot is R + 1,
    findall(I,(member(robot(I,_,_),Board)),AllRobots),
    length(AllRobots, L),
    NextRobot is PossibleNextRobot mod L.
next_world(X,_,X).

checkSolved(X,[]) :-
    currentBoardSolved(X),!.
checkSolved(X,X).

%!  picture(?N, ?Picture) is det
%   
%   True if *Picture* is the screen representation of the world *N*.

picture(N, M) :-
    boardToString(true, N, M).

% Solve
main :-
    current_prolog_flag(argv, ['--solve'|_]),!,
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    %time(solve(B, Moves)),
    solve(B, Moves),
    write_solve(Moves),nl,
    halt(0).

main :-
    current_prolog_flag(argv, ['--solve_time'|_]),!,
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    time(solve(B, _)),!,
    %solve(B, Moves),
    %write_solve(Moves),nl,
    halt(0).

% Test
main :- 
    current_prolog_flag(argv, Argv),
    member(Opt, Argv),
    atom_concat('--test=[', TestOpt, Opt),!,% check if --test option is present
    atom_concat(RandMOpt, ']', TestOpt),
    atomic_list_concat([RobotAtom,Move], ',', RandMOpt),    
    atom_number(RobotAtom, Robot),
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    zet(B,Robot,Move,NewBoard),
    boardToString(false, NewBoard, SB),
    write(SB),
    halt(0).
    
% Genereren
main :-
    current_prolog_flag(argv, Argv),
    member(Opt, Argv),
    atom_concat('--gen=[', TestOpt, Opt),!, % check if --gen option is present
    atom_concat(RandMOpt, ']', TestOpt),
    atomic_list_concat([AantalRobotsAtom,WidthAtom, HeightAtom], ',', RandMOpt),
    atom_number(AantalRobotsAtom, AantalRobots),
    atom_number(WidthAtom, Width),
    atom_number(HeightAtom, Height),
    createMap(AantalRobots,Width, Height, B),!,
    boardToString(false, B, SB),!,
    write(SB),
    solve(B, Moves),
    write_solve(Moves),nl,
    halt(0).


% Interactieve modus
main :-
    current_prolog_flag(argv, Argv),
    member(Opt, Argv),
    atom_concat('--game=[', TestOpt, Opt),!, % check if --gen option is present
    atom_concat(Path, ']', TestOpt),
    write(Path),nl,
    open(Path, read, X),
    read_string(X, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    animate([currentRobot(0)|B],picture,next_world).

% default
main:-
    halt(0).
