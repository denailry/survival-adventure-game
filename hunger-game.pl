/* 
	The Hunger Game - Survival Adventure Game 
	Created by: Daniel Ryan Levyson
				Hamdi Ahmad Zuhri
				Dimas Aditia Pratikto
				Luthfi Ahmad Mujahid Hadiana
*/
:- dynamic(peta/1).
:- dynamic(baris/2).
:- dynamic(player_health/1).
:- dynamic(player_hunger/1).
:- dynamic(player_point/2).
:- dynamic(player_inventory/1).
:- dynamic(player_weapon/1).
:- dynamic(enemy_list/1).
:- dynamic(enemy_point/2).
:- dynamic(weapon_list/1).
:- dynamic(water_list/1).
:- dynamic(food_list/1).
:- dynamic(medicine_list/1).
:- dynamic(game_state/1).
/* Primitif Global */
	/* Primitif List */
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
	/* Setter Getter Game State */
		game_state(0).
		set_state(S) :-
			retract(game_state(_)),
			asserta(game_state(S)).
	/* Others */
		/* True when two points is same */
		is_coor_equal([],[]).
		is_coor_equal([X|P1], [X|P2]) :-
			is_coor_equal(P1,P2).	
		/* State Validation */
		validate_running :-
			game_state(State),
			State == 0,
			write('Game is not started yet.\n'),
			!,
			fail.
		validate_running :-
			game_state(State),
			State == 1,
			!.
		validate_running :-
			game_state(State),
			State == 2,
			write('Game is Over. You died.\n'),
			!,
			fail.
		validate_stop :-
			game_state(State),
			State == 0, 
			!.
		validate_stop :-
			game_state(State),
			State == 1,
			write('Game has been started.\n'),
			!,
			fail.
		validate_stop :-
			game_state(State),
			State == 2.
		validate_quit :-
			game_state(State),
			State == 0,
			write('Game is not started yet.\n'),
			!,
			fail.
		validation_quit :-
			game_state(State),
			State == 1, 
			!.
		validate_quit :-
			game_state(State),
			State == 2.

/* Primitif Map Game*/
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
	create_map(0,[]).
	create_map(X,M):- 
		baris(X,L) ,
		C is X-1,create_map(C,U),
		append(U,[L],M), !.
	/*Init Peta*/
	init_map:-
		create_map(12,M),
		asserta(peta(M)),!.
	/*Update Peta setelah terjadi perubahan*/
	update_map :- 
		retract(peta(_)) , 
		create_map(12,M),
		asserta(peta(M)),!.
	/*Selektor Element Peta*/
	elmt_map(I, J , X) :-
		peta(Matrix),
		nth0(I, Matrix, Row),
		nth0(J, Row, X).
	/*Setter Element Peta*/
	set_map_el(I,J,X) :- 
		Brs is I+1 , 
		Kol is J+1 , 
		baris(Brs,L1) , 
		change(L1,Kol,X,L2) , 
		retract(baris(Brs,_)) ,
		asserta(baris(Brs,L2)),
		update_map,!.
	/*Print Peta*/
	print_matriks([]) :- !.
	print_matriks([A|B]) :-
	 	print_bar(A),
	 	print_matriks(B), !.
	print_bar([H|T]) :-
	 	write(H),
	 	print_bar(T), !.
	print_bar([]) :- nl, !.
	/* Reset map and put all of game objects on the map */
	redraw_map :-
		reset_row(1,11),
		put_player,
		hole_list(Holes),
		put_holes(Holes),
		food_list(Food),
		put_foods(Food),
		water_list(Water),
		put_water(Water),
		medicine_list(Medicine),
		put_medicines(Medicine),
		weapon_list(Weapon),
		put_weapons(Weapon),
		enemy_list(Enemies),
		put_enemies(Enemies).
	reset_row(MinNumber, MinNumber) :-
		init_map, !.
	reset_row(MinNumber, Indexer) :-
		retract(baris(Indexer, _)),
		asserta(baris(Indexer, [?,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,?])),
		V is Indexer-1,
		reset_row(MinNumber, V).
	/*Look*/
	print_batas_brs(N,Max,Max):- 
		elmt_map(N,Max,H), 
		write(H) ,
		nl.
	print_batas_brs(N,Min,Max) :- 
		elmt_map(N,Min,H), 
		write(H), 
		I is Min +1 , 
		print_batas_brs(N,I,Max),!.
	print_batas_mapk(MaxBrs , MaxBrs , MinKol,MaxKol) :- 
		print_batas_brs(MaxBrs,MinKol,MaxKol).
	print_batas_mapk(MinBrs , MaxBrs , MinKol,MaxKol) :- 
		print_batas_brs(MinBrs, MinKol,MaxKol), 
		I is MinBrs +1 , 
		print_batas_mapk(I , MaxBrs , MinKol,MaxKol),!.

/* Primitif Object Game */
	/* Food Object */
		food_power(30).
		food_list([
			[[3,1],'korea rice'],
			[[7,1],'japan rice'],
			[[8,1],'apple'],
			[[5,5],'dragon egg'],
			[[5,7],'kuro-kuro'],
			[[3,8],'potato'],
			[[2,10],'hambagu'],
			[[5,11],'spaghetti'],
			[[8,11],'lasagna'],
			[[7,14],'dragon egg'],
			[[4,14],'kuro - kurp'],
			[[2,15],'mushroom'],
			[[4,17],'apple'],
			[[8,19],'japan rice'],
			[[5,20],'korean rice'],
			[[6,20],'hambagu']
			]).
		set_foods(Foods) :-
			retract(food_list(_)),
			asserta(food_list(Foods)).
		food_point(Food, X, Y) :-
			nth0(0, Food, Point),
			Point = [X,Y].
		food_name(Food,Name):-
			nth0(2,Food,Name).
		put_foods([]) :- !.
		put_foods([F|Foods]) :-
			food_point(F, X, Y),
			set_map_el(X, Y, 'F'),
			put_foods(Foods).
		is_player_on_food([]) :- !, fail.
		is_player_on_food([Food|_]) :-
			player_point(PRow, PColumn),
			food_point(Food, Row, Column),
			is_coor_equal([PRow,PColumn],[Row,Column]), 
			!.
		is_player_on_food([_|Foods]) :-
			is_player_on_food(Foods).

		search_food([],Name,Point,[]) :- 
			!.
		search_food([H|T],Name,Point,L):- 
			H=[P,N] ,
			N == Name , 
			P == Point,
			L = H , 
			!.
		search_food([H|T],Name,Point,L):- 
			search_food(T,Name,Point,Z) , 
			Z=L , 
			!.

	/* Water Object */
		water_power(30).
		water_list([
			[[3,2],'kangen water'],
			[[9,1],'holy water'],
			[[2,5],'mineral water'],
			[[6,7],'mineral water'],
			[[8,10],'kangen water'],
			[[4,12],'kangen water'],
			[[5,12],'healty water'],
			[[4,13],'lake water'],
			[[5,13],'holy water'],
			[[2,17],'holy water'],
			[[7,19],'mineral water'],
			[[7,20],'healthy water']
			]).
		set_water(Water) :-
			retract(water_list(_)),
			asserta(water_list(Water)).
		water_point(Water, X, Y) :-
			nth0(0, Water, Point),
			Point = [X,Y].
		water_name(Water,Name):-
			nth0(2,Water,Name).
		put_water([]) :- !.
		put_water([W|Water]) :-
			water_point(W, X, Y),
			set_map_el(X, Y, 'W'),
			put_water(Water).
		is_player_on_water([]) :- !, fail.
		is_player_on_water([W|_]) :-
			player_point(PRow, PColumn),
			water_point(W, Row, Column),
			is_coor_equal([PRow,PColumn],[Row,Column]), 
			!.
		is_player_on_water([_|Waters]) :-
			is_player_on_water(Waters).

		search_water([],Name,Point,[]) :- 
			!.
		search_water([H|T],Name,Point,L):- 
			H=[P,N] ,
			N == Name , 
			P == Point,
			L = H , 
			!.
		search_water([H|T],Name,Point,L):- 
			search_food(T,Name,Point,Z) , 
			Z=L , 
			!.
		
	/* Medicine Object */
		medicine_power(40).
		medicine_list([
			[[2,3],'panadol'],
			[[8,4],'betadine'],
			[[10,6],'oskadon'],
			[[6,8],'anti-biotic'],
			[[9,10],'paracetamol'],
			[[3,11],'madu rasa'],
			[[5,15],'panadol'],
			[[9,15],'oskadon'],
			[[2,20],'tango']
			]).
		set_medicines(Medicines) :-
			retract(medicine_list(_)),
			asserta(medicine_list(Medicines)).
		medicine_point(Medicine, X, Y) :-
			nth0(0, Medicine, Point),
			Point = [X,Y].
		medicine_name(Medicine,Name):-
			nth0(2,Medicine,Name).
		put_medicines([]) :- !.
		put_medicines([M|Medicines]) :-
			medicine_point(M, X, Y),
			set_map_el(X, Y, 'M'),
			put_medicines(Medicines).
		is_player_on_medicine([]) :- !, fail.
		is_player_on_medicine([Medicine|_]) :-
			player_point(PRow, PColumn),
			medicine_point(Medicine, Row, Column),
			is_coor_equal([PRow,PColumn],[Row,Column]), 
			!.
		is_player_on_medicine([_|Medicines]) :-
			is_player_on_medicine(Medicines).
		search_medicine([],Name,Point,[]) :- 
			!.
		search_medicine([H|T],Name,Point,L):- 
			H=[P,N] ,
			N == Name , 
			P == Point,
			L = H , 
			!.
		search_medicine([H|T],Name,Point,L):- 
			search_food(T,Name,Point,Z) , 
			Z=L , 
			!.
	/* Weapon Object */
		weapon_list([
			[10, [5,1],'catapult'],
			[20, [1,3],'axe'],
			[30, [5,8],'kanya'],
			[40, [7,10],'yasha'],
			[50, [6,12],'daedalus'],
			[60, [9,16],'monkey king bar'],
			[70, [10,19],'trisula of poseidon'],
			[80, [8,20],'divine rapier'],
			[90, [1,20],'book of sadiku']
			]).
		set_weapons(Weapons) :-
			retract(weapon_list(_)),
			asserta(weapon_list(Weapons)).
		weapon_point(Weapon, X , Y) :-
			nth0(1, Weapon, Point),
			Point = [X,Y].
		weapon_damage(Weapon, Damage) :-
			nth0(0, Weapon, Damage).
		put_weapons([]) :- !.
		put_weapons([W|Weapons]) :-
			weapon_point(W,X,Y),
			set_map_el(X, Y, '#'),
			put_weapons(Weapons).
		is_player_on_weapon([]) :- !, fail.
		is_player_on_weapon([Weapon|_]) :-
			player_point(PRow, PColumn),
			weapon_point(Weapon , Row , Column),
			is_coor_equal([PRow,PColumn],[Row,Column]), 
			!.
		is_player_on_weapon([_|Weapons]) :-
			is_player_on_weapon(Weapons).
		status_weapon(Weapon) :-
			nl,
			weapon_damage(Weapon, Damage),
			write(Damage),
			write(' Damage\n').
		search_weapon([],Name,Point,[]) :- 
			!.
		search_weapon([H|T],Name,Point,L):- 
			H=[_,P,N] ,
			N == Name , 
			P == Point,
			L = H , 
			!.
		search_weapon([H|T],Name,Point,L):- 
			search_weapon(T,Name,Point,Z) , 
			Z=L , 
			!.
	/* Setter Getter List of Holes */
		hole_list([
			[5,4],[6,4],[9,4],[9,5],
			[9,6],[7,6],[6,6],[5,6],
			[4,6],[4,7],[4,8],[7,7],
			[1,11],[1,12],[8,12],[8,13],
			[8,14],[5,16],[4,16],[3,16],
			[6,18],[7,18],[6,19],[5,19],
			[4,19],[4,20]
			]).
		set_holes(Holes) :-
			retract(hole_list(_)),
			asserta(hole_list(Holes)).
		hole_point(Hole, X, Y) :-
			nth0(0, Hole, X),
			nth0(1, Hole, Y).
		put_holes([]) :- !.
		put_holes([H|Holes]) :-
			hole_point(H, X, Y),
			set_map_el(X, Y, 'X'),
			put_holes(Holes).
		is_object_on_hole([], Point) :- !, fail.
		is_object_on_hole([Hole|Holes], Point) :-
			hole_point(Hole, Row, Column),
			is_coor_equal(Point,[Row,Column]), 
			!.
		is_object_on_hole([Hole|Holes], Point) :-
			is_object_on_hole(Holes, Point).
	/* Enemy Object */
		enemy(1, ['Goblin Kurus', 100, 10, [0,0], 1]).
		enemy(2, ['Goblin Botak', 100, 10, [0,0], 2]).
		enemy(3, ['Serigala Ganteng', 100, 10, [0,0], 3]).
		enemy(4, ['Harimau Tampan', 100, 10, [0,0], 4]).
		enemy(5, ['Ogre Bumbum', 120, 20, [0,0], 5]).
		enemy(6, ['Serigala Bumbum', 120, 20, [0,0], 6]).
		enemy(7, ['Goblin Bumbum', 120, 20, [0,0], 7]).
		enemy(8, ['Tikus Cantik', 150, 30, [0,0], 8]).
		enemy(9, ['Tikus Gila', 150, 30, [0,0], 9]).
		enemy(10, ['Raja Semut', 200, 50, [0,0], 10]).
		set_enemies(Enemies) :-
			retract(enemy_list(_)),
			asserta(enemy_list(Enemies)).
		set_enemy(Enemy) :-
			enemy_list([E|Enemies]),
			set_enemy(Enemy,[E|Enemies],Res),
			set_enemies(Res).
		set_enemy(Enemy,[E|Enemies],Res) :-
			enemy_id(Enemy, Id),
			enemy_id(E, EId), 
			Id == EId,
			append([Enemy],Enemies,Res),
			enemy_name(Enemy, Name),
			!.
		set_enemy(Enemy, [E|Enemies],Res) :-
			enemy_id(Enemy, Id),
			enemy_id(E, EId),
			Id \== EId,
			set_enemy(Enemy,Enemies,DRes),
			append([E],DRes,Res).
		set_point(Enemy, Point, DEnemy) :-
			change(Enemy, 4, Point, DEnemy).
		enemy_point(Enemy, Point) :-
			nth0(3, Enemy, Point).
		enemy_point(Enemy, X, Y) :-
			enemy_point(Enemy, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		enemy_damage(Enemy, Damage) :-
			nth0(2, Enemy, Damage).
		enemy_name(Enemy, Name) :-
			nth0(0, Enemy, Name).
		enemy_id(Enemy, Id) :-
			nth0(4, Enemy, Id).
		enemy_atacked([Enemy|Rest]):- 
			player_point(X,Y),
			Enemy = (It,[Name,Health,Damage,[X,Y],Id]),
			player_weapon(X),
			X = [_,WDamage],
			Health_Att = Health - WDamage,
			C_Enemy = (It,[Name,Health_Att,Damage,[X,Y],Id]),
			set_enemy(C_Enemy),
			enemy_atacked(Rest).
		enemy_atacked([Enemy|Rest]):-
			enemy_atacked(Rest).
		enemy_atacked([]):- !.
		
		/* Randomized Enemies Location */
		init_enemies(EnemyNumber) :-
			init_enemies(EnemyNumber, [], List),
			asserta(enemy_list(List)),
			!.
		init_enemies(0, List, List) :- !.
		init_enemies(EnemyNumber, Temp, List) :-
			N is EnemyNumber-1,
			random(1, 10, Row),
			random(1, 20, Column),
			init_enemy(EnemyNumber, Row, Column, Enemy, Temp),
			init_enemies(N, [Enemy|Temp], List).
		init_enemy(N, Row, Column, Enemy, Enemies) :-
			invalidate_init_pos([Row, Column], Enemies),
			random(1, 10, DRow),
			random(1, 20, DColumn),
			init_enemy(N, DRow, DColumn, Enemy, Enemies),
			!.
		init_enemy(N, Row, Column, Enemy, Enemies) :-
			enemy(N, DEnemy),
			change(DEnemy, 4, [Row,Column], Enemy).

		/* Avoid same enemies location when initialization */ 
		invalidate_init_pos(Point, [Enemy|EnemyList]) :-
			enemy_point(Enemy, EnemyPoint),
			is_coor_equal(Point, EnemyPoint),
			!.
		invalidate_init_pos(Point, [Enemy|EnemyList]) :-
			invalidate_init_pos(Point, EnemyList).
		invalidate_init_pos(Point,[]) :- 
			hole_list(Holes),
			is_object_on_hole(Holes, Point).
		/* Avoid enemy move to hole or boundaries */
		validate_pos(X, Y) :-
			X >= 1, X =< 10,
			Y >= 1, Y =< 20,
			hole_list(Holes),
			\+is_object_on_hole(Holes,[X,Y]).
		put_enemies([]) :- !.
		put_enemies([E|Enemies]) :-
			length(Enemies, Len),
			enemy_point(E, X, Y),
			set_map_el(X, Y, 'E'),
			put_enemies(Enemies).
		trigger_enemy :-
			enemy_list(Enemies),
			trigger_enemy(Enemies).
		trigger_enemy([]) :- !.
		trigger_enemy([E|Enemies]) :-
			player_point(Row, Column),
			enemy_point(E, Point),
			is_coor_equal(Point, [Row, Column]),
			attack_player(E),
			!,
			trigger_enemy(Enemies).
		trigger_enemy([E|Enemies]) :-
			random(1,4,Direction),
			move_enemy(E, Direction),
			trigger_enemy(Enemies),
			!.
		trigger_enemy([E|Enemies]) :-
			trigger_enemy([E|Enemies]).
		attack_player(Enemy) :-
			player_health(CurrentHealth),
			enemy_damage(Enemy, Damage),
			enemy_name(Enemy, Name),
			Health is CurrentHealth-Damage,
			set_player_health(Health),
			write('You are attacked by '),
			write(Name),
			nl,
			validate_player.
		move_enemy(Enemy, Direction) :-
			Direction == 0,
			enemy_point(Enemy, Row, Column),
			DRow is Row-1,
			validate_pos(DRow, Column),
			set_point(Enemy, [DRow,Column], DEnemy),
			set_enemy(DEnemy), 
			write(Row), write(' '), write(Column), write(' '),
			write(DRow), write(' '), write(Column),
			nl,
			!.
		move_enemy(Enemy, Direction) :-
			Direction == 1,
			enemy_point(Enemy, Row, Column),
			DColumn is Column+1,
			validate_pos(Row, DColumn),
			set_point(Enemy, [Row,DColumn], DEnemy),
			set_enemy(DEnemy),
			!.
		move_enemy(Enemy, Direction) :-
			Direction == 2,
			enemy_point(Enemy, Row, Column),
			DRow is Row+1,
			validate_pos(DRow, Column),
			set_point(Enemy, [DRow,Column], DEnemy),
			set_enemy(DEnemy),
			!.
		move_enemy(Enemy, Direction) :-
			Direction == 3,
			enemy_point(Enemy, Row, Column),
			DColumn is Column-1,
			validate_pos(Row, DColumn),
			set_point(Enemy, [Row,DColumn], DEnemy),
			set_enemy(DEnemy),
			!.

	/* Player Object */
		player_health(100).
		player_hunger(100).
		player_thirst(100).
		player_point(1,1).
		player_inventory([]).
		player_capacity(5).
		player_weapon([a,10]).
		set_player_health(Health) :-
			retract(player_health(_)),
			asserta(player_health(Health)).
		set_player_hunger(Hunger) :-
			retract(player_hunger(_)),
			asserta(player_hunger(Hunger)).
		set_player_thirst(Thirst) :-
			retract(player_thrist(_)),	
			asserta(player_thirst(Thirst)).
		set_player_point(X, Y) :-
			retract(player_point(_, _)),
			asserta(player_point(X, Y)).
		set_player_inventory(Inventory) :-
			retract(player_inventory(_)),
			asserta(player_inventory(Inventory)).
		set_player_weapon(Weapon) :-
			retract(player_weapon(_)),
			asserta(player_weapon(Weapon)).
		put_player :-
			player_point(X, Y),
			set_map_el(X, Y, 'P').
		take_item(Item) :-
			player_inventory(Inventory),	
			player_capacity(Capacity),
			length(Inventory, Len),
			Len < Capacity,
			set_player_inventory([Item|Inventory]),
			!.
		take_item(Item) :-
			write('Your inventory is full.\n'), 
			!, 
			fail.
		validate_player :-
			player_health(Health),
			Health =< 0,
			set_state(2).
		status_inventory([]) :- !.
		status_inventory([Object|Inventory]) :-
			Object = [ItemName|_],
			write(ItemName), write(' | '),
			status_inventory(Inventory).
		search_inventory([],X,[]):-!.
		search_inventory([H|T],X,Obj):-
			H = [ItemName|_],
			ItemName == X,
			Obj = H,
			!.
		search_inventory([H|T],X,Obj):-
			search_inventory(T,X,Z),
			Obj = Z,
			!.
		drop_item(Obj) :-
			player_inventory(Inventory),
			length(Inventory, Len),
			Len > 0,
			select(Obj,Inventory,LAfter),
			set_player_inventory(LAfter),
			!.
		drop_item(Item) :- 
			!, 
			fail.

		look_food :-
			food_list(Food), 
			player_point(X,Y),
			Point = [X,Y],
			search_food(Food,_,Point,L),
			L /== [] 

/*Command-Command utama*/
	start:- 
		validate_stop,
		set_state(1),
		set_player_point(1,1),
		init_enemies(10),
		redraw_map.
	help :- 
		write('Available commands:\n'),
		write('start. -- start the game!\n'),
		write('help. -- show available commands\n'),
		write('quit. -- quit the game\n'),
		write('look. -- look around you\n'),
		write('n. s. e. w. -- move\n'),
		write('map. -- look at the map and detect enemies (need radar to use)\n'),
		write('take(Object). -- pick up an object\n'),
		write('drop(Object). -- drop an object use(Object). -- use an object\n'),
		write('attack. -- attack enemy that crosses your path\n'),
		write('status. -- show your status\n'),
		write('save(Filename). -- save your game\n'),
		write('load(Filename). -- load previously saved game\n').
	quit :-
		validate_quit,
		set_state(0),
		write('Keluar dari permainan.\n').
	look :- 
		validate_running,
		trigger_enemy,
		redraw_map,
		player_point(Row,Column),
		MinBrs is Row-1 ,
		MaxBrs is Row+1 , 
		MinKol is Column-1 ,
		MaxKol is Column+1 , 
		print_batas_mapk(MinBrs,MaxBrs,MinKol,MaxKol).
	s :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Row < 10,
		Brs is Row+1,
		set_player_point(Brs, Column).
	n :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Row > 1,
		Brs is Row-1,
		set_player_point(Brs, Column).
	e :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Column < 20,
		Kol is Column+1,
		set_player_point(Row, Kol).
	w :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Column > 1,
		Kol is Column-1,
		set_player_point(Row, Kol).
	map :- 
		validate_running,
		redraw_map,
		peta(M), 
		print_matriks(M), !.
	take(Object) :-
		validate_running,
		trigger_enemy,
		player_point(X,Y),
		Point = [X,Y],
		medicine_list(Medicines),
		is_player_on_medicine(Medicines),
		search_medicine(Medicines,Object,Point,Temp),
		Temp \== [] ,
		Item = [Object,'M'],
		take_item(Item),
		select([[X,Y],Object],Medicines,LAfter),
		set_medicines(LAfter),
		write('Medicine has been taken.\n'),
		!.
	take(Object) :-
		validate_running,
		trigger_enemy,
		player_point(X,Y),
		Point = [X,Y],
		food_list(Foods),
		is_player_on_food(Foods),
		search_food(Foods,Object,Point,Temp),
		Temp \== [] ,
		Item = [Object,'F'],
		take_item(Item), 
		select([[X,Y],Object],Foods,LAfter),
		set_foods(LAfter),
		write('Food has been taken.\n'),
		!.
	take(Object) :-
		validate_running,
		trigger_enemy,
		player_point(X,Y),
		Point = [X,Y],
		water_list(Water),
		is_player_on_water(Water),
		search_water(Water,Object,Point,Temp),
		Temp \== [] ,
		Item = [Object,'W'],
		take_item(Item),
		select([[X,Y],Object],Water,LAfter),
		set_water(LAfter), 
		write('Water has been taken.\n'),
		!.
	take(Object) :-
		validate_running,
		trigger_enemy,
		player_point(X,Y),
		Point = [X,Y],
		weapon_list(Weapons),
		is_player_on_weapon(Weapons),
		search_weapon(Weapons,Object,Point,Temp),
		Temp \== [] ,
		Temp = [Damage,P,_],
		Item = [Object,Damage,'#'],
		take_item(Item),
		select([_,[X,Y],Object],Weapons,LAfter),
		set_weapons(LAfter),
		write('Weapon has been taken.\n'),
		!.
	take(Object) :-
		validate_running,
		trigger_enemy,
		write('No object taken.\n'),
		!,
		fail.
	use(Object) :-
		validate_running,
		trigger_enemy,
		Object == 'M',
		medicine_power(Power),
		player_health(CurrentHealth),
		Health is Power+CurrentHealth,
		set_player_health(Health),
		write('Increased health by '),
		write(Power),
		nl,
		!.
	use(Object) :-
		validate_running,
		trigger_enemy,
		Object == 'F',
		food_power(Power),
		player_hunger(CurrentHunger),
		Hunger is Power+CurrentHunger,
		set_player_hunger(Hunger),
		write('Increased hunger by '),
		write(Power),
		nl,
		!.
	use(Object) :-
		validate_running,
		trigger_enemy,
		Object == 'W',
		water_power(Power),
		player_thirst(CurrentThirst),
		Thirst is Power+CurrentThirst,
		set_player_thirst(Thirst),
		write('Increased thirst by '),
		write(Power),
		nl,
		!.
	use(Object) :-
		validate_running,
		trigger_enemy,
		Object == '#',
		change_weapon,
		!.
	use(Object) :-
		validate_running,
		trigger_enemy,
		write('No action.\n'),
		!,
		fail.
	status :-
		validate_running,
		player_health(Health),
		player_hunger(Hunger),
		player_thirst(Thirst),
		player_weapon(Weapon),
		player_inventory(Inventory),
		write('Health    : '), write(Health), nl,
		write('Hunger    : '), write(Hunger), nl,
		write('Thirst    : '), write(Thirst), nl,
		write('Weapon    : '), status_weapon(Weapon), nl,
		write('Inventory : '), status_inventory(Inventory), nl.

	drop(Name) :-
		validate_running,
		trigger_enemy,
		player_inventory(Inventory),
		search_inventory(Invetory,Name,Obj),
		Obj = [ItemName,Kode],
		Kode == 'W',	
		water_list(Water),
		drop_item(Obj), 
		player_point(X,Y),
		set_water([[[X,Y],ItemName]|Water]),
		write('Water has been dropped.\n'),
		!.
	drop(Name) :-
		validate_running,
		trigger_enemy,
		player_inventory(Inventory),
		search_inventory(Invetory,Name,Obj),
		Obj = [ItemName,Kode],
		Kode == 'M',	
		medicine_list(Medicine),
		drop_item(Obj), 
		player_point(X,Y),
		set_medicines([[[X,Y],ItemName]|Medicine]),
		write('Medicine has been dropped.\n'),
		!.
	drop(Name) :-
		validate_running,
		trigger_enemy,
		player_inventory(Inventory),
		search_inventory(Invetory,Name,Obj),
		Obj = [ItemName,Kode],
		Kode == 'F',	
		food_list(Food),
		drop_item(Obj), 
		player_point(X,Y),
		set_foods([[[X,Y],Name]|Food]),
		write('Food has been dropped.\n'),
		!.
	drop(Name) :-
		validate_running,
		trigger_enemy,
		player_inventory(Inventory),
		search_inventory(Invetory,Name,Obj),
		Obj = [ItemName,Damage,Kode],
		/*Kode == '#',	
		weapon_list(Weapon),
		drop_item(Obj), 
		player_point(X,Y),*/
		set_weapons([[Damage,[X,Y],Name]|Weapon]),
		write('Weapon has been dropped.\n'),
		!.
	drop(Name) :-
		write('No object dropped.\n'),
		!,
		fail.
	attack:- 
		player_weapon([Name,_]),
		Name \== "-",
		enemy_attacked(enemy_list),
		!.
	attack:- 
		write('Salah Blog\n'),
		!,
		fail.
