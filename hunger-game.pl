/* 
	The Hunger Game - Survival Adventure Game 
	Created by: Daniel Ryan Levyson
				Hamdi Ahmad Zuhri
				Dimas Aditia Pratikto
				Luthfi Ahmad Mujahid Hadiana
*/

/* Setter Getter Map */
set_map(_) :-
    retract(gameMap(_)),
    fail.
set_map(M) :-
    asserta(gameMap(M)).
get_map(M) :-
    gameMap(M).

/* Setter Getter List Food pada Game */
set_foods(_) :-
	retract(foodList(_)),
	fail.
set_foods(L) :-
	asserta(foodList(M)).
get_foods(L) :-
	foodList(L).

/* Setter Getter List Water pada Game  */
set_water(_) :-
	retract(waterList(_)),
	fail.
set_water(L) :-
	asserta(waterList(M)).
get_water(L) :-
	waterList(L).

/* Setter Getter List Medicine pada Game */
set_medicines(_) :-
	retract(medicineList(_)),
	fail.
set_medicines(L) :-
	asserta(medicineList(M)).
get_medicines(L) :-
	medicineList(L).

/* Setter Getter List Weapon pada Game */
set_weapons(_) :-
	retract(weaponList(_)),
	fail.
set_weapons(L) :-
	asserta(weaponList(M)).
get_weapons(L) :-
	weaponList(L).

/* Setter Getter List Enemy pada Game */
set_enemies(_) :-
	retract(enemyList(_)),
	fail.
set_enemies(E) :-
	asserta(enemyList(E)).
get_enemies(E) :-
	enemyList(E).

/* Setter Getter Player */
set_player(_) :-
	retract(player(_)),
	fail.
set_player(Health, Hunger, Thirst, Weapon, Inventory) :-
	asserta(player(Health, Hunger, Thirst, Weapon, Inventory)).
get_player(Health, Hunger, Thirst, Weapon, Inventory) :-
	player(Health, Hunger, Thirst, Weapon, Inventory).

/* Setter Getter Hole */
set_holes(_) :-
	retract(holes(_)),
	fail.
set_holes(H) :-
	asserta(holes(H)).
get_holes(H) :-
	holes(H).

/* Setter Getter Game State */
set_state(S) :-
	asserta(is_running(S)).
get_state(S) :-
	is_running(S).

:- dynamic(peta/1).
:- dynamic(baris/2).

/*Inisialisasi Baris (Fakta Baris)*/
baris(1,[?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?]).
baris(2,[?,p,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(3,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(4,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(5,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(6,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(7,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(8,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(9,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(10,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(11,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
baris(12,[?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?]).
/*Append ke dalam list*/
bikinMap(0,[]).
bikinMap(X,M):- 
    baris(X,L) ,
    C is X-1,bikinMap(C,U),
    append(U,[L],M), !.
initPeta:-bikinMap(12,M),asserta(peta(M)),!.
updatePeta :- retract(peta(_)) , bikinMap(12,M),asserta(peta(M)),!.
/*Selektor Element Peta*/
elmt(I, J , X) :-
    peta(Matrix),
    nth0(I, Matrix, Row),
    nth0(J, Row, X).

/*Ubah Isi List*/
splitL(X,0,[],X).
splitL([H|L],X,A,B) :-  C is X-1 , splitL(L,C,M,B) , append([H],M,A) ,!.
delLast([_|[]],[]).
delLast([H|L],X) :- delLast(L,Y) , append([H],Y,X),!.
change(L1, I , Value, L2) :- splitL(L1,I,M,N) ,delLast(M,X), append(X,[Value],Z) , append(Z,N,L2).

/*Setter Element Peta*/
set(I,J,X) :- Brs is I+1 , Kol is J+1 , baris(Brs,L1) , change(L1,Kol,X,L2) , retract(baris(Brs,_)) ,asserta(baris(Brs,L2)),updatePeta,!.

/*Print Peta*/
printMatriks([]).
printMatriks([A|B]) :-
 printBar(A),
 printMatriks(B).
printBar([H|T]) :-
 write(H),
 printBar(T).
printBar([]) :- nl.
printPeta :- peta(M) , printMatriks(M).

/* Menampilkan daftar perintah yang dapat dieksekusi */
help.

/* Memulai permainan */
start :-
	set_player(100, 100, 100, 0, []),
	set_map([
		['-', '-','-','-','-'], 
		['-', '-','-','-','-']
	]),
	set_foods([[4,2],[8,2],[9,2],[6,6],[6,8],[4,9],[3,11],[6,12],[9,12],[8,15],[5,15],[3,16],[5,18],[9,20],[6,21],[7,21]]),
	set_medicines([[3,4],[9,5],[11,7],[7,9],[10,11],[4,12],[6,16],[10,16],[3,21]]),
	set_water([[4,3],[10,1],[3,6],[7,8],[9,11],[5,13],[6,13],[5,14],[6,14],[3,18],[8,20],[8,21]]),
	set_weapons([[6,2],[2,4],[6,9],[8,11],[7,13],[10,17],[11,20],[9,21],[2,21]]),
	set_hole([[6,5],[7,5],[10,5],[10,6],[10,7],[8,7],[7,7],[6,7],[5,7],[5,8],[5,9],[8,8],[2,12],[2,13],[9,13],[9,14],[9,15],[6,17],[5,17],[4,17],[7,19],[8,19],[7,20],[6,20],[5,20],[5,21]]),
	init_enemies(10),
	help.

/* Mengakhiri permainan */
quit :-
	set_state(0),
	write('Keluar dari permainan.').

/** 
 * Menampilkan peta dengan cara mengambil
 * dengan cara mengambil tiap baris dengan get_map
 * dan memanggil print_baris untuk menampilkan
 * setiap titik pada peta
 */
print_map :-
	get_map(Map),
	print_map(Map).
print_map([]).
print_map([Row|Remain]) :-
	print_baris(Row),
	nl,
	print_map(Remain).
print_baris([]).
print_baris([Column|Remain]) :-
	write(Column),
	print_baris(Remain).