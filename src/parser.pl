:- module(parser, [parse/3]).
:- set_prolog_flag(double_quotes, codes).

% muur(X1, Y1, X2, Y2).

parse(Board) --> top_vakje(Board, 0 ,0),!.

top_vakje(Board, Y, _) --> bottom_right_corner, new_line, {Board = [height(Y)]}.
top_vakje(Board, 0, X) --> connector, new_line, !, {append([width(X)], Board2, Board)}, vakje(Board2, 0, 0).
top_vakje(Board, Y, _) --> connector, new_line, !, vakje(Board, Y, 0).
top_vakje(Board, Y, X) --> connector, horizontale_muur(Board, Y, X, Nboard), {NX is X+1}, top_vakje(Nboard, Y, NX).

horizontale_muur(Board, Y, X, Nboard) --> horizontal, {NY is Y - 1, append([muur(X, Y, X, NY)], Nboard, Board)}.
horizontale_muur(Board, _, _, Board) --> " ".


vakje(Board, Y, X) --> {NY is Y+1}, verticale_muur(Board, Y, X, Board2), new_line, !, top_vakje(Board2, NY, 0).
vakje(Board, Y, X) --> {NX is X+1}, verticale_muur(Board, Y, X, Board2), opvulling(Board2, Y, X, Board3), vakje(Board3, Y, NX).

verticale_muur(Board, Y, X, Nboard) --> vertical, {NX is X - 1, append([muur(X, Y, NX, Y)], Nboard, Board)}.
verticale_muur(Board, _, _, Board) --> " ".

new_line --> "\r\n".
new_line --> "\n".

connector --> horizontal.
connector --> vertical.
connector --> top_left_corner.
connector --> top_right_corner.
connector --> bottom_left_corner.
connector --> bottom_right_corner.
connector --> vertical_connector_left.
connector --> vertical_connector_right.
connector --> horizontal_connector_top.
connector --> horizontal_connector_bottom.
connector --> cross_connector.
connector --> " ".


opvulling(Board, Y, X, Nboard) --> robot0, {append([robot(0, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot1, {append([robot(1, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot2, {append([robot(2, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot3, {append([robot(3, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot4, {append([robot(4, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot5, {append([robot(5, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot6, {append([robot(6, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot7, {append([robot(7, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot8, {append([robot(8, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> robot9, {append([robot(9, X, Y)], Nboard, Board)}.
opvulling(Board, Y, X, Nboard) --> doel, {append([doel(X, Y)], Nboard, Board)}.
opvulling(Board, _, _, Board) --> " ".

horizontal --> "\u2501".
vertical --> "\u2503".
top_left_corner --> "\u250f".
top_right_corner --> "\u2513".
bottom_left_corner --> "\u2517".
bottom_right_corner --> "\u251b".
vertical_connector_left --> "\u2523".
vertical_connector_right --> "\u252b".
horizontal_connector_top --> "\u2533".
horizontal_connector_bottom --> "\u253b".
cross_connector --> "\u254b".

robot0 --> "\u25a3".
robot1 --> "\u25a0".
robot2 --> "\u25b2".
robot3 --> "\u25c6".
robot4 --> "\u25c7".
robot5 --> "\u25c8".
robot6 --> "\u25c9".
robot7 --> "\u25e9".
robot8 --> "\u25ed".
robot9 --> "\u25f2".
doel --> "\u25ce".