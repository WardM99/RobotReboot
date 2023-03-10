:- module(print, [test_printen/0]).

initial(vakje(coordinaat(0,0), muren(1,0,0,1), vulling(1))).
initial(vakje(coordinaat(1,0), muren(1,1,0,0), vulling(e))).
initial(vakje(coordinaat(2,0), muren(1,0,0,1), vulling(e))).
initial(vakje(coordinaat(3,0), muren(1,1,1,0), vulling(e))).

initial(vakje(coordinaat(0,1), muren(0,0,0,1), vulling(e))).
initial(vakje(coordinaat(1,1), muren(0,0,1,0), vulling(e))).
initial(vakje(coordinaat(2,1), muren(0,0,0,0), vulling(0))).
initial(vakje(coordinaat(3,1), muren(1,1,0,0), vulling(e))).

initial(vakje(coordinaat(0,2), muren(0,0,0,1), vulling(e))).
initial(vakje(coordinaat(1,2), muren(1,1,0,0), vulling(d))).
initial(vakje(coordinaat(2,2), muren(0,0,0,1), vulling(e))).
initial(vakje(coordinaat(3,2), muren(0,1,0,0), vulling(e))).

initial(vakje(coordinaat(0,3), muren(0,1,1,1), vulling(e))).
initial(vakje(coordinaat(1,3), muren(0,0,1,1), vulling(e))).
initial(vakje(coordinaat(2,3), muren(0,0,1,0), vulling(e))).
initial(vakje(coordinaat(3,3), muren(0,1,1,0), vulling(e))).

initial_board(Bord) :-
    findall(Vakje, initial(Vakje), Bord).


% alleen naar E en S kijken, behalve bij Y=0 ook naar N en bij X=0 ook naar W
% voor de hoeken kijken of er vakje volgt, zo niet, hoek hoektekenen


test_printen :-
    initial_board(Bord),
    test_printen_eerste_lijn(Bord,0),nl,
    test_printen_vervolg(Bord, 0, 0),nl,
    test_printen_vervolg_vervolg(Bord, 0,0),nl,
    test_printen_vervolg(Bord, 0, 1),nl,
    test_printen_vervolg_vervolg(Bord, 0,1),nl,
    test_printen_vervolg(Bord, 0, 2),nl,
    test_printen_vervolg_vervolg(Bord, 0,2),nl,
    test_printen_vervolg(Bord, 0, 3),nl,
    test_printen_vervolg_vervolg(Bord, 0,3),nl.


test_printen_eerste_lijn(Bord,3) :-
    write_top_square(Bord, 3).
test_printen_eerste_lijn(Bord, X) :-
    write_top_square(Bord, X),
    NewX is X + 1,
    test_printen_eerste_lijn(Bord, NewX).

test_printen_vervolg(Bord, 3, Y) :-
    write_square(Bord, 3, Y).
test_printen_vervolg(Bord, X, Y) :-
    write_square(Bord, X, Y),
    NewX is X + 1,
    test_printen_vervolg(Bord, NewX, Y).

test_printen_vervolg_vervolg(Bord, 3, Y) :-
    write_bottom_square(Bord, 3, Y).
test_printen_vervolg_vervolg(Bord, X, Y) :-
    write_bottom_square(Bord, X, Y),
    NewX is X + 1,
    test_printen_vervolg_vervolg(Bord, NewX, Y).


% De top van een vakje tekeken. Wordt alleen gedaan bij de eerste rij
write_top_square(Bord, 0) :- 
    \+member(vakje(coordinaat(0,0), muren(_,1,_,_), _), Bord),
    top_left_corner, horizontal, horizontal.
write_top_square(Bord, 0) :-
    member(vakje(coordinaat(0,0), muren(_,1,_,_), _), Bord),
    top_left_corner, horizontal, horizontal_connector_bottom.
write_top_square(Bord, X) :-
    \+member(vakje(coordinaat(X,0), muren(_,1,_,_), _), Bord),
    horizontal, horizontal.
write_top_square(Bord, X) :-
    member(vakje(coordinaat(X,0), muren(_,1,_,_), _), Bord),
    NewX is X + 1,
    member(vakje(coordinaat(NewX, 0), _, _), Bord),
    horizontal, horizontal_connector_top.
write_top_square(Bord, X) :-
    member(vakje(coordinaat(X,0), muren(_,1,_,_), _), Bord),
    NewX is X + 1,
    \+member(vakje(coordinaat(NewX, 0), _, _), Bord),
    horizontal, top_right_corner.

% De inhoud van het vakje tekenen en de oosterse muur, als het nodig is.
write_square(Bord, 0, Y) :-
    member(vakje(coordinaat(0,Y), muren(_,E,_,_), vulling(V)), Bord),
    vertical, write_filling(V), write_east_wall(E).
write_square(Bord, X, Y) :-
    member(vakje(coordinaat(X,Y), muren(_,E,_,_), vulling(V)), Bord),
    write_filling(V), write_east_wall(E).

% De bottom van een vakje tekenen.
write_bottom_square(Bord, 0, Y) :-
    member(vakje(coordinaat(0,Y), muren(_,_,0,_), _), Bord),
    vertical, nsbp, nsbp.
write_bottom_square(Bord, 0, Y) :-
    member(vakje(coordinaat(0,Y), muren(_,_,1,_), _), Bord),
    NewY is Y + 1,
    member(vakje(coordinaat(0,NewY),_,_), Bord),
    vertical_connector_left, horizontal, nsbp.
write_bottom_square(Bord, 0, Y) :-
    member(vakje(coordinaat(0,Y), muren(_,_,1,_), _), Bord),
    NewY is Y + 1,
    \+member(vakje(coordinaat(0,NewY),_,_), Bord),
    bottom_left_corner, horizontal, nsbp.
write_bottom_square(Bord, X, Y) :-
    member(vakje(coordinaat(X,Y), muren(_,_,S,_), _), Bord),
    write_south_wall(S), nsbp.


write_filling(0) :- robot0.
write_filling(1) :- robot1.
write_filling(d) :- doel.
write_filling(e) :- nsbp.

write_east_wall(0) :- nsbp.
write_east_wall(1) :- vertical.

write_south_wall(0) :- nsbp.
write_south_wall(1) :- horizontal.

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

robot0 :- write("\u25a3").
robot1 :- write("\u25a0").

doel :- write("\u25ce").

nsbp :- write("\u00a0").