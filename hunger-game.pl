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

/* Menampilkan pesan awal permainan */
start_message.
/* Menampilkan daftar perintah yang dapat dieksekusi */
help.

/* Memulai permainan */
start :-
	start_message,
	set_player(100, 100, 100, 0, []),
	set_map([
		['-', '-','-','-','-'], 
		['-', '-','-','-','-']
	]),
	set_foods([[0,0],[3,1],[4,4]]),
	help.

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
change_point(X, Y, Char) :-
	write('DEBUG '),
	get_map(Map),
	write('DEBUG '),
	V is X-1,
	write('DEBUG '),
	pop_row(Map, V, Y, Char),
	set_map(Map).
pop_row([Row|Remain], X, Y, Char) :-
	write('DEBUG1 '),
	X == 0,
	V is Y-1,
	write('DEBUG1 '),
	DRow is ['-', '-','-','-','-'],
	write('DEBUG1 '),
	pop_col(DRow, V, Char),
	write('DEBUG1 '),
	Row is DRow.
pop_row([Row|Remain], X, Y, Char) :-
	write('DEBUG2 '),
	X > 0,
	V is Y-1,
	write('DEBUG2'),
	pop_row(Remain, V, Y, Char).
pop_col([Dot|Remain], Y, Char) :-
	Y == 0,
	Dot is Char.
pop_col([Dot|Remain], Y, Char) :-
	Y > 0,
	V is Y-1,
	DDot is Dot,
	pop_col(DDot, V, Char),
	Dot is DDot.