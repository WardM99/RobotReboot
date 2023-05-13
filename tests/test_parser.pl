:- begin_tests(parser).
:- load_files('../src/parser.pl', [import(all)]).

test(parserMap) :-
    open('extra/test_borden/voorbeeld.txt', read, X),
    read_string(X, _, Str),
    string_codes(Str, Codes),
    parse([muur(0,0,0,-1),muur(1,0,1,-1),muur(2,0,2,-1),muur(3,0,3,-1),width(4),muur(0,0,-1,0),robot(1,0,0),muur(2,0,1,0),muur(4,0,3,0),muur(3,1,3,0),muur(0,1,-1,1),robot(0,2,1),muur(4,1,3,1),muur(1,2,1,1),muur(0,2,-1,2),doel(1,2),muur(2,2,1,2),muur(4,2,3,2),muur(0,3,-1,3),muur(1,3,0,3),muur(4,3,3,3),muur(0,4,0,3),muur(1,4,1,3),muur(2,4,2,3),muur(3,4,3,3),height(4)], Codes, []).

test(parserAlleMuren) :-
    open('extra/test_borden/allemuren.txt', read, X),
    read_string(X, _, Str),
    string_codes(Str, Codes),
    parse([muur(0,0,0,-1),muur(1,0,1,-1),muur(2,0,2,-1),muur(3,0,3,-1),width(4),muur(0,0,-1,0),robot(1,0,0),muur(2,0,1,0),muur(4,0,3,0),muur(3,1,3,0),muur(0,1,-1,1),muur(2,1,1,1),robot(0,2,1),muur(4,1,3,1),muur(0,2,0,1),muur(1,2,1,1),muur(2,2,2,1),muur(0,2,-1,2),doel(1,2),muur(2,2,1,2),muur(4,2,3,2),muur(0,3,-1,3),muur(1,3,0,3),muur(4,3,3,3),muur(0,4,0,3),muur(1,4,1,3),muur(2,4,2,3),muur(3,4,3,3),height(4)], Codes, []).

test(parserAlleMuren) :-
    open('extra/test_borden/allemuren.txt', read, X),
    read_string(X, _, Str),
    string_codes(Str, Codes),
    parse([muur(0,0,0,-1),muur(1,0,1,-1),muur(2,0,2,-1),muur(3,0,3,-1),width(4),muur(0,0,-1,0),robot(1,0,0),muur(2,0,1,0),muur(4,0,3,0),muur(3,1,3,0),muur(0,1,-1,1),muur(2,1,1,1),robot(0,2,1),muur(4,1,3,1),muur(0,2,0,1),muur(1,2,1,1),muur(2,2,2,1),muur(0,2,-1,2),doel(1,2),muur(2,2,1,2),muur(4,2,3,2),muur(0,3,-1,3),muur(1,3,0,3),muur(4,3,3,3),muur(0,4,0,3),muur(1,4,1,3),muur(2,4,2,3),muur(3,4,3,3),height(4)], Codes, []).
    

:- end_tests(parser).