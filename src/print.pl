:- module(print, [boardToString/2, write_solve/1]).

boardToString(Bord, S) :-
    print_top_lijn(Bord, 0, S),!.

print_top_lijn(Bord, Y, S) :-
    print_top_lijn_vakje(Bord, Y, 0, S).

print_top_lijn_vakje(Bord, Y, X, S) :- 
    \+member(width(X), Bord),
    print_connector(Bord, Y, X, Connector),
    print_top_lijn_vakje_muur(Bord, Y, X, Muur),
    string_concat(Connector, Muur, CM),!,
    NX is X + 1,
    print_top_lijn_vakje(Bord, Y, NX, NextString),
    string_concat(CM, NextString,S),!.

print_top_lijn_vakje(Bord, Y, X, S) :- 
    member(width(X), Bord),
    \+member(height(Y), Bord),
    print_connector(Bord, Y, X, Connector),
    string_concat(Connector, "\n", ConnectorNewline),!,
    print_lijn(Bord, Y, NewString),
    string_concat(ConnectorNewline,NewString,S),!.

print_top_lijn_vakje(Bord, Y, X, S) :- 
    member(width(X), Bord),
    member(height(Y), Bord),
    print_connector(Bord, Y, X, Connector),
    string_concat(Connector, "\n", S),!.

print_top_lijn_vakje_muur(Bord, Y, X, S) :-
    NY is Y - 1,
    \+member(muur(X,Y,X,NY),Bord),
    nsbp(S).

print_top_lijn_vakje_muur(Bord, Y, X, S) :-
    NY is Y - 1,
    member(muur(X,Y,X,NY),Bord),
    horizontal(S).


print_lijn(Bord, Y, S) :-
    print_lijn_vakje(Bord, Y, 0, S).

print_lijn_vakje(Bord, Y, X, S) :-
    \+member(width(X), Bord),
    print_lijn_vakje_muur(Bord, Y, X, Muur),
    print_opvulling(Bord, Y, X, Opvulling),
    string_concat(Muur, Opvulling, MO),!,
    NX is X + 1,
    print_lijn_vakje(Bord, Y, NX, NextString),
    string_concat(MO, NextString, S),!.

print_lijn_vakje(Bord, Y, X, S) :-
    member(width(X), Bord),
    print_lijn_vakje_muur(Bord, Y, X, Muur),
    string_concat(Muur, "\n", MuurEnNewLine),!,
    NY is Y + 1,
    print_top_lijn(Bord, NY, NextString),
    string_concat(MuurEnNewLine, NextString, S),!.

print_lijn_vakje_muur(Bord, Y, X, S) :-
    NX is X - 1,
    member(muur(X,Y,NX,Y), Bord),
    vertical(S).

print_lijn_vakje_muur(Bord, Y, X, S) :-
    NX is X - 1,
    \+member(muur(X,Y,NX,Y), Bord),
    nsbp(S).


print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    cross_connector(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical_connector_right(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical_connector_left(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    horizontal_connector_top(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    horizontal_connector_bottom(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    top_left_corner(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    top_right_corner(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    bottom_left_corner(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    bottom_right_corner(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    horizontal(S).
print_connector(Bord, Y, X, S) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical(S).
print_connector(_, _, _, S) :- nsbp(S).


print_opvulling(Bord, Y, X, S) :- 
    member(robot(R, X,Y),Bord),
    robot(R,S).
print_opvulling(Bord, Y, X, S) :- 
    member(doel(X,Y),Bord),
    doel(S).
print_opvulling(_,_,_,S) :-
    nsbp(S).


horizontal("\u2501").
vertical("\u2503").
top_left_corner("\u250f").
top_right_corner("\u2513").
bottom_left_corner("\u2517").
bottom_right_corner("\u251b").
vertical_connector_left("\u2523").
vertical_connector_right("\u252b").
horizontal_connector_top("\u2533").
horizontal_connector_bottom("\u253b").
cross_connector("\u254b").

robot(0,"\u25a3").
robot(1,"\u25a0").
robot(2,"\u25b2").
robot(3,"\u25c6").
robot(4,"\u25c7").
robot(5,"\u25c8").
robot(6,"\u25c9").
robot(7,"\u25e9").
robot(8,"\u25ed").
robot(9,"\u25f2").

doel("\u25ce").

nsbp(" ").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_solve([(R,M)]) :-
    write(R),write_upper_move(M).
write_solve([(R,M)|T]) :-
    write_solve(T),
    write(","),write(R),write_upper_move(M).


write_upper_move(l) :- write("L").
write_upper_move(r) :- write("R").
write_upper_move(d) :- write("D").
write_upper_move(u) :- write("U").