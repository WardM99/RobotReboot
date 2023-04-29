% Animate library
:- module(animate, [animate/3, red/1, white/1]).

%!  animate(+S, :P, :NW) is det
%
%   Animate a game starting from world *S*.
%   *P* is a predicate that outputs the picture representation of a world, and NW is a predicate that outputs the next world based on the start world
animate(S, P, NW) :-
    current_input(In),
    PF =.. [P, S, Picture],
    call(PF),
    clear(Clear),
    format("~w", [Clear]),
    draw(Picture),
    read_line_to_string(In, Line),
    NWF =.. [NW, S, Line, Next_world],
    call(NWF),
    animate(Next_world, P, NW).


%!  draw(++Picture) is det
%
%   Draws the *Picture*.
draw(text(M, Colour)) :-
    blink(B),
    white(C),
    format("~w~w", [Colour, M]), nl, format("~w~w~w",[B,C,">_ "]).

% ANSI ESC code to clear entire screen
clear("\x1B\c").

% ANSI ESC Code to colour text red
red("\033[38;5;160m").
white("\033[38;5;255m").
blink("\033[5m").

