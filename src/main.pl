:- use_module(animate).
:- use_module(print).

:- initialization main.

%!  next_world(?X:int, +I:string, -Y:int) is det
%!  next_world(+X:int, ?I:string, -Y:int) is det
%   
%   Based on the current world and command-line input, outputs the new world.
next_world(_, "R", 0).
next_world(X, _, Y) :- Y is X + 1.

%!  next_world(?N, ?Picture) is det
%   
%   True if *Picture* is the screen representation of the world *N*.
picture(N, text(M, Colour)) :-
    number_string(N, M), red(Colour).

% main :- animate(0,picture,next_world), halt.

main :- test_printen, nl, halt.
