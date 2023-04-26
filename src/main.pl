:- initialization(main, main).
%:- use_module(animate).
:- use_module(print).
:- use_module(parser).
:- use_module(game).


%!  next_world(?X:int, +I:string, -Y:int) is det
%!  next_world(+X:int, ?I:string, -Y:int) is det
%   
%   Based on the current world and command-line input, outputs the new world.
next_world(_, "R", 0).
next_world(X, _, Y) :- Y is X + 1.

%!  next_world(?N, ?Picture) is det
%   
%   True if *Picture* is the screen representation of the world *N*.

% picture(N, text(M, Colour)) :-
%    number_string(N, M), red(Colour).

% main :- animate(0,picture,next_world), halt.

%main :- test_printen, nl, halt.


main:-
    read_string(user_input, _, Str),
    string_codes(Str, Codes),
    parse(B, Codes, []),
    zet(B, 0, l, NB),
    zet(NB, 0, u, NNB),
    zet(NNB, 0, d, NNNB),
    test_printen(NNNB),
    halt(0).