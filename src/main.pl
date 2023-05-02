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
%next_world(_, "R", 0).
%next_world(X, _, Y) :- Y is X + 1.

next_world(_, "", _) :- halt(0).
next_world(X, _, X).

%!  next_world(?N, ?Picture) is det
%   
%   True if *Picture* is the screen representation of the world *N*.

picture(N, text(M, Colour)) :-
    boardToString(N, M), white(Colour).

% main :- animate(0,picture,next_world), halt.

%main :- test_printen, nl, halt.

% Solve
main :-
    current_prolog_flag(argv, ['--solve'|_]),
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    %time(solve(B, Moves)),
    solve(B, Moves),
    write_solve(Moves),nl,
    halt(0).

% Test
main :- 
    current_prolog_flag(argv, Argv),
    member(Opt, Argv),
    atom_concat('--test=[', TestOpt, Opt), % check if --test option is present
    atom_concat(RandMOpt, ']', TestOpt),
    atomic_list_concat([RobotAtom,Move], ',', RandMOpt),    
    atom_number(RobotAtom, Robot),
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    zet(B,Robot,Move,NewBoard),
    boardToString(NewBoard, SB),
    write(SB),
    halt(0).
    
% Genereren
main :-
    current_prolog_flag(argv, Argv),
    member(Opt, Argv),
    atom_concat('--gen=[', TestOpt, Opt), % check if --test option is present
    atom_concat(RandMOpt, ']', TestOpt),
    atomic_list_concat([AantalRobotsAtom,WidthAtom, HeightAtom], ',', RandMOpt),
    atom_number(AantalRobotsAtom, AantalRobots),
    atom_number(WidthAtom, Width),
    atom_number(HeightAtom, Height),
    createMap(AantalRobots,Width, Height, B),!,
    unique(B),
    boardToString(B, SB),!,
    write(SB),
    halt(0).

% default: TODO: should be empty
main:-
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    boardToString(B, SB),
    write(SB).
    %open('map.txt', read, X),
    %read_string(X, _, Str),
    %string_codes(Str, Codes),
    %parse(B, Codes, []),
    %animate(B,picture,next_world).

unique([]).
unique([X|Xs]) :-
    unique(Xs),
    \+member(X, Xs).
unique([X|Xs]) :-
    member(X,Xs),
    write(X),nl.