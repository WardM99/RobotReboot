% Animate library
:- module(animate, [animate/3, red/1, white/1, clear/1]).

%!  animate(+S, :P, :NW) is det
%
%   Animate a game starting from world *S*.
%   *P* is a predicate that outputs the picture representation of a world, and NW is a predicate that outputs the next world based on the start world
animate(S, P, NW) :-
    PF =.. [P, S, Picture],
    call(PF),
    clear(Clear),
    format("~w", [Clear]),
    format("\033[?25l"),
    draw(Picture),
    handleInput(Move),
    NWF =.. [NW, S, Move, Next_world],
    call(NWF),
    animate(Next_world, P, NW).


%!  draw(++Picture) is det
%
%   Draws the *Picture*.
draw(M) :-
    format(M).
    %format("~w~w", [Colour, M]).

% ANSI ESC code to clear entire screen
clear("\x1B\c").

% ANSI ESC Code to colour text red
red("\033[38;5;160m").
white("\033[38;5;255m").
blink("\033[5m").
resetBlink("\033[25m").

handleInput(Move) :-
    get_single_char(Code),
    (
        Code is 122,!,Move is 1 % z = up
    ;   Code is 115,!,Move is 2 % s = down
    ;   Code is 113,!,Move is 3 % q = left
    ;   Code is 100,!,Move is 4 % d = right
    ;   Code is 13,!,Move is 10  % enter = stop (only final screen)
    ;   Code is 119,!,Move is 1 % w = up
    ;   Code is 97,!,Move is 3  % a = left
    ;   Code is 9,!,Move is 5   %tab = changeRobot
    ;   Code is 32,!,Move is 0  %ESC = stop
    ;   !,Move is -1
    ).
