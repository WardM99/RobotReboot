:- module(print, [test_printen/1, write_solve/1]).

test_printen(Bord) :-
    print_top_lijn(Bord, 0).


print_top_lijn(Bord, Y) :-
    print_top_lijn_vakje(Bord, Y, 0).

print_top_lijn_vakje(Bord, Y, X) :- 
    \+member(width(X), Bord),
    print_connector(Bord, Y, X),
    print_top_lijn_vakje_muur(Bord, Y, X),
    NX is X + 1,
    print_top_lijn_vakje(Bord, Y, NX).

print_top_lijn_vakje(Bord, Y, X) :- 
    member(width(X), Bord),
    \+member(height(Y), Bord),
    print_connector(Bord, Y, X),
    nl,
    print_lijn(Bord, Y).

print_top_lijn_vakje(Bord, Y, X) :- 
    member(width(X), Bord),
    member(height(Y), Bord),
    print_connector(Bord, Y, X),
    nl.

print_top_lijn_vakje_muur(Bord, Y, X) :-
    NY is Y - 1,
    \+member(muur(X,Y,X,NY),Bord),
    nsbp.

print_top_lijn_vakje_muur(Bord, Y, X) :-
    NY is Y - 1,
    member(muur(X,Y,X,NY),Bord),
    horizontal.


print_lijn(Bord, Y) :-
    print_lijn_vakje(Bord, Y, 0).

print_lijn_vakje(Bord, Y, X) :-
    \+member(width(X), Bord),
    print_lijn_vakje_muur(Bord, Y, X),
    print_opvulling(Bord, Y, X),
    NX is X + 1,
    print_lijn_vakje(Bord, Y, NX).

print_lijn_vakje(Bord, Y, X) :-
    member(width(X), Bord),
    print_lijn_vakje_muur(Bord, Y, X),
    nl,
    NY is Y + 1,
    print_top_lijn(Bord, NY).

print_lijn_vakje_muur(Bord, Y, X) :-
    NX is X - 1,
    member(muur(X,Y,NX,Y), Bord),
    vertical.

print_lijn_vakje_muur(Bord, Y, X) :-
    NX is X - 1,
    \+member(muur(X,Y,NX,Y), Bord),
    nsbp.


print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    cross_connector.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical_connector_right.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical_connector_left.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    horizontal_connector_top.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    horizontal_connector_bottom.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X, Y, X, PY), Bord),
    top_left_corner.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    top_right_corner.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    bottom_left_corner.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(PX,Y, PX, PY), Bord),
    member(muur(X,PY, PX, PY), Bord),
    bottom_right_corner.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, X, PY), Bord),
    member(muur(PX,Y, PX, PY), Bord),
    horizontal.
print_connector(Bord, Y, X) :-
    PX is X - 1,
    PY is Y - 1,
    member(muur(X, Y, PX, Y), Bord),
    member(muur(X,PY, PX, PY), Bord),
    vertical.
print_connector(_, _, _) :- write(" ").


print_opvulling(Bord, Y, X) :- 
    member(robot(0, X,Y),Bord),
    robot0.
print_opvulling(Bord, Y, X) :- 
    member(robot(1, X,Y),Bord),
    robot1.
print_opvulling(Bord, Y, X) :- 
    member(doel(X,Y),Bord),
    doel.
print_opvulling(_,_,_) :-
    write(" ").


horizontal :- write("\u2501").
vertical :- write("\u2503").
top_left_corner :- write("\u250f").
top_right_corner :- write("\u2513").
bottom_left_corner :- write("\u2517").
bottom_right_corner :- write("\u251b").
vertical_connector_left :- write("\u2523").
vertical_connector_right :- write("\u252b").
horizontal_connector_top :- write("\u2533").
horizontal_connector_bottom :- write("\u253b").
cross_connector :- write("\u254b").

robot0 :- write("\u25a3").
robot1 :- write("\u25a0").

doel :- write("\u25ce").

nsbp :- write(" ").

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