/* 
	The Hunger Game - Survival Adventure Game 
	Created by: Daniel Ryan Levyson
				Hamdi Ahmad Zuhri
				Dimas Aditia Pratikto
				Luthfi Ahmad Mujahid Hadiana
*/

/* Setter Getter Map */
setMap(_) :-
    retract(gameMap(_)),
    fail.
setMap(M) :-
    asserta(gameMap(M)).
getMap(M) :-
    gameMap(M).

/* Setter Getter List Food pada Game */
setFoodList(_) :-
	retract(foodList(_)),
	fail.
setFoodList(L) :-
	asserta(foodList(M)).
getFoodList(L) :-
	foodList(L).

/* Setter Getter List Water pada Game  */
setWaterList(_) :-
	retract(waterList(_)),
	fail.
setWaterList(L) :-
	asserta(waterList(M)).
getWaterList(L) :-
	waterList(L).

/* Setter Getter List Medicine pada Game */
setMedicineList(_) :-
	retract(medicineList(_)),
	fail.
setMedicineList(L) :-
	asserta(medicineList(M)).
getMedicineList(L) :-
	medicineList(L).

/* Setter Getter List Weapon pada Game */
setWeaponList(_) :-
	retract(weaponList(_)),
	fail.
setWeaponList(L) :-
	asserta(weaponList(M)).
getWeaponList(L) :-
	weaponList(L).

/* Setter Getter List Enemy pada Game */
setEnemyList(_) :-
	retract(enemyList(_)).
setEnemyList(E) :-
	asserta(enemyList(E)).
getEnemyList(E) :-
	enemyList(E).

/* Setter Getter Inventory Player */
setInventory(I) :-
	retract(inventory(_)).
setInventory(I) :-
	asserta(inventory(I)).
getInventory() :-
	inventory(I).

/* Menampilkan peta */
PrintMap([]).
PrintMap([H|T]) :-
	PrintBaris(H),
	nl,
	PrintMap(T).
/* Menginisiasi map kosong */
InitMap.
/* Menginisiasi kolom kosong pada map */
InitKol.
/* Menginisiasi baris kosong pada map */
InitBar.
/* Mengisi petak pada map dengan Food */
PutFood(Food).
/* Mengisi petak pada map dengan Water */
PutWater(Water).
/* Mengisi petak pada map dengan Medicine */
PutMedicine(Medicine).
/* Mengisi petak pada map dengan Weapon */
PutWeapon(Weapon).
/* Mengisi petak pada map dengan Enemy */
InitEnemy(Enemy).
/* Menghapus object dari permainan */
DeleteObject(Type, Object).
/* Menambahkan object dari permainan */
AddObject(Type, Object).
/* Menghapus object dari inventory player */
DeleteItem(Object).
/* Menambahkan object ke inventory player */
AddItem(Object).
/* Memanfaatkan item yang ada di inventory */
UseItem(Object).
/* Memindahkan player ke koordinat (x, y) */
MovePlayer(X, Y).
/* Enemy menyerang player */
AttackPlayer.
/* Player menyerang enemy */
AttackEnemy.
/* Menginsiasi enemy untuk melakukan attack atau 
	move sesuai kondisi */
TriggerEnemy.
/* Menyimpan segala informasi game yang sedang
	berlangsung pada file eksternal */
SaveGame.
/* Mengakses segala informasi game yang telah
	disimpan pada file eksternal */
LoadGame.