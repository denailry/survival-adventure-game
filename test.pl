set_list(_) :-
    retract(myList(_)),
    fail.
set_list(L) :-
    asserta(myList(L)).
get_list(L) :-
    myList(L).

start :-
	set_list(['G','T','B']).
add_list(X) :-
	get_list(L),
	set_list([X|L]).
print_list :-
	get_list(L),
	write(L),
	nl.

merge(A, B, [A|B]).
merge(A, 'LOL').

copy([]).
copy([Aa|A], B) :-
	copy(A, B, Aa).
copy([], B, C) :-
	C \== 0,
	write(C),
	nl,
	copy([], [C|B], 0).
copy([Aa|A], B, C) :-
	write(C),
	nl,
	copy(A, [C|B], Aa).
copy([], [], 0) :-
	write('END'),
	nl.

reverse([Aa|A], B) :-
	reverse(A, [Aa|B]).
reverse([], []).

change_element(X, Char) :-
	get_list(L),
	V is X-1,
	LL is [],
	change(L, V, Char, LL).
	set_list(L).
change([E|L], X, Char, LL) :-
	X > 0,
	V is X-1,
	write('E'),
	nl,
	change(L, V, Char, LL).
change([E|L], X, Char, LL) :-
	X == 0,
	write(E),
	nl,
	LL is ['C'].

lul(0, []).
lul(X, L) :-
	X > 0,
	V is X-1,
	lul(V, [3|L]).
lol(X, L) :-
	lul(X, [3|L]), 
	write(L).