/* 
	The Hunger Game - Survival Adventure Game 
	Created by: Daniel Ryan Levyson
				Hamdi Ahmad Zuhri
				Dimas Aditia Pratikto
				Luthfi Ahmad Mujahid Hadiana
*/
:- dynamic(peta/1).
:- dynamic(baris/2).
:- dynamic(playerCoor/2).

/*Primitif Tambahan untuk List*/
/*Ubah Isi List*/
	splitL(X,0,[],X).
	splitL([H|L],X,A,B) :-  
		C is X-1 , 
		splitL(L,C,M,B) , 
		append([H],M,A) ,!.
	/*delLast(M,X) */
	delLast([_|[]],[]).
	delLast([H|L],X) :- 
		delLast(L,Y) , 
		append([H],Y,X),!.
	/*change(L1, I , Value, L2) Mengubah Nilai L1 indeks ke I dengan value lalu disimpan di L2*/ 					
	change(L1, I , Value, L2) :-
		splitL(L1,I,M,N) ,
		delLast(M,X), 
		append(X,[Value],Z) , 
		append(Z,N,L2).


/* Setter Getter Map */
	/*Inisialisasi Baris (Fakta Baris)*/
	baris(1,[?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?]).
	baris(2,[?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?]).
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
	/*Init Peta*/
	initPeta:-
		bikinMap(12,M),
		asserta(peta(M)),!.
	/*Update Peta setelah terjadi perubahan*/
	updatePeta :- 
		retract(peta(_)) , 
		bikinMap(12,M),
		asserta(peta(M)),!.
	/*Selektor Element Peta*/
	elmtMap(I, J , X) :-
		peta(Matrix),
		nth0(I, Matrix, Row),
		nth0(J, Row, X).
	/*Setter Element Peta*/
	setElMap(I,J,X) :- 
		Brs is I+1 , 
		Kol is J+1 , 
		baris(Brs,L1) , 
		change(L1,Kol,X,L2) , 
		retract(baris(Brs,_)) ,
		asserta(baris(Brs,L2)),
		updatePeta,!.

/* Setter Getter List Food pada Game */
/*setFoodList(_) :-
	retract(foodList(_)),
	fail.
setFoodList(L) :-
	asserta(foodList(M)).
getFoodList(L) :-
	foodList(L).*/

/* Setter Getter List Water pada Game  */
/*setWaterList(_) :-
	retract(waterList(_)),
	fail.
setWaterList(L) :-
	asserta(waterList(M)).
getWaterList(L) :-
	waterList(L).*/

/* Setter Getter List Medicine pada Game */
/*setMedicineList(_) :-
	retract(medicineList(_)),
	fail.
setMedicineList(L) :-
	asserta(medicineList(M)).
getMedicineList(L) :-
	medicineList(L).*/

/* Setter Getter List Weapon pada Game */
/*setWeaponList(_) :-
	retract(weaponList(_)),
	fail.
setWeaponList(L) :-
	asserta(weaponList(M)).
getWeaponList(L) :-
	weaponList(L).*/

/* Setter Getter List Enemy pada Game */
/*setEnemyList(_) :-
	retract(enemyList(_)).
setEnemyList(E) :-
	asserta(enemyList(E)).
getEnemyList(E) :-
	enemyList(E).*/

/* Setter Getter Inventory Player */
/*setInventory(I) :-
	retract(inventory(_)).
setInventory(I) :-
	asserta(inventory(I)).
getInventory() :-
	inventory(I).*/

/* Setter Getter Posisi Player */
setPlayerCoor(X,Y) :- 
	asserta(playerCoor(X,Y)).
getPlayerCoor(X,Y) :- 
	playerCoor(X,Y).

/* Menampilkan peta */
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

/*Command-Command utama*/
	/*Start*/
	start:- 
		initPeta ,
		setPlayerCoor(1,1),
		setElMap(1,1,p).
	/*Help*/
	help :- 
		write('Available commands:\nstart. -- start the game!\nhelp. -- show available commands\nquit. -- quit the game\nlook. -- look around you\nn. s. e. w. -- move\nmap. -- look at the map and detect enemies (need radar to use)\ntake(Object). -- pick up an object\ndrop(Object). -- drop an object use(Object). -- use an object\nattack. -- attack enemy that crosses your path\nstatus. -- show your status\nsave(Filename). -- save your game\n load(Filename). -- load previously saved game\n').

	/*Look*/
	printBatasBrs(N,Max,Max):- 
		elmt(N,Max,H), 
		write(H) ,
		nl.
	printBatasBrs(N,Min,Max) :- 
		elmt(N,Min,H), 
		write(H), 
		I is Min +1 , 
		printBatasBrs(N,I,Max),!.

	printBatasPetak(MaxBrs , MaxBrs , MinKol,MaxKol) :- 
		printBatasBrs(MaxBrs,MinKol,MaxKol).
	printBatasPetak(MinBrs , MaxBrs , MinKol,MaxKol) :- 
		printBatasBrs(MinBrs, MinKol,MaxKol) , 
		I is MinBrs +1 , 
		printBatasPetak(I , MaxBrs , MinKol,MaxKol),!.

	look :- playerCoor(X,Y),
		MinBrs is X-1 ,
		MaxBrs is X+1 , 
		MinKol is Y-1 ,
		MaxKol is Y+1 , 
		printBatasPetak(MinBrs , MaxBrs , MinKol,MaxKol) .

	/*Movement*/
	s :- 
		getPlayerCoor(X,Y),
		Brs is Y+1,
		retract(playerCoor(X,Y)),
		setPlayerCoor(playerCoor(X,Brs)),
		setElMap(X,Y,-),
		setElMap(X,Brs,p).
	n :- 
		getPlayerCoor(X,Y),
		Brs is Y-1,
		retract(playerCoor(X,Y)),
		setPlayerCoor(playerCoor(X,Brs)),
		setElMap(X,Y,-),
		setElMap(X,Brs,p).
	e :- 
		getPlayerCoor(X,Y),
		Kol is X+1,
		retract(playerCoor(X,Y)),
		setPlayerCoor(playerCoor(Kol,Y)),
		setElMap(X,Y,-),
		setElMap(Kol,Y,p).
	w :- 
		getPlayerCoor(X,Y),
		Kol is X-1,
		retract(playerCoor(X,Y)),
		setPlayerCoor(playerCoor(Kol,Y)),
		setElMap(X,Y,-),
		setElMap(Kol,Y,p).