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
		/* Universal object searhing */
		search_object(Name, Item, 'F') :-
			food_list(Foods),
			search_object(Name, Foods, Item), !.
		search_object(Name, Item, 'W') :-
			water_list(Water),
			search_object(Name, Water, Item), !.
		search_object(Name, Item, 'M') :-
			medicine_list(Medicines),
			search_object(Name, Medicines, Item), !.
		search_object(Name, Item, '#') :-
			weapon_list(Weapons),
			search_object(Name, Weapons, Item), !.
		search_object(Name, [Item|List], Item) :- !.
		search_object(Name, [], Item) :- !, fail.
		search_object(Name, [Search|List], Item) :-
			nth0(0, Search, NameItem),
			Name == NameItem,
			search_object(Name, [Search|List], Search), !.
		search_object(Name, [Search|List], Item) :-
			search_object(Name, List, Item).
		/* Universal delete object from map */
		del_object(Object, 'F') :-
			food_list(Foods),
			select(Object, Foods, List),
			set_foods(List).
		del_object(Object, 'M') :-
			medicine_list(Medicines),
			select(Object, Medicines, List),
			set_medicines(List).
		del_object(Object, 'W') :-
			water_list(Water),
			select(Object, Water, List),
			set_medicines(List).
		del_object(Object, '#') :-
			weapon_list(Weapons),
			select(Object, Weapons, List),
			set_weapons(List).
		format_item(Item, 'F', ['Food', Power, 'F']) :-
			food_power(Power).
		format_item(Item, 'W', ['Water', Power, 'W']) :-
			water_power(Power).
		format_item(Item, 'M', ['Medicine', Power, 'M']) :-
			medicine_power(Power).
		format_item(Item, '#', [Name, Damage, '#']) :-
			weapon_name(Item, Name),
			weapon_damage(Item, Damage).
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
		put_holes,
		put_enemies.
	redraw_look :-
		reset_row(1, 11),
		put_player,
		put_weapons,
		put_water,
		put_foods,
		put_medicines,
		put_enemies.
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
			[3,1],[7,1],[8,1],[5,5],
			[5,7],[3,8],[2,10],[5,11],
			[8,11],[7,14],[4,14],[2,15],
			[4,17],[8,19],[5,20],[6,20]
			]).
		set_foods(Foods) :-
			retract(food_list(_)),
			asserta(food_list(Foods)).
		food_point(Food, X, Y) :-
			nth0(0, Food, X),
			nth0(1, Food, Y).
		put_foods :-
			food_list(Foods),
			put_foods(Fodds).
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

	/* Water Object */
		water_power(30).
		water_list([
			[3,2],[9,1],[2,5],[6,7],
			[8,10],[4,12],[5,12],[4,13],
			[5,13],[2,17],[7,19],[7,20]
			]).
		set_water(Water) :-
			retract(water_list(_)),
			asserta(water_list(Water)).
		water_point(Water, X, Y) :-
			nth0(0, Water, X),
			nth0(1, Water, Y).
		put_water :-
			water_list(Water),
			put_water(Water).
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

	/* Medicine Object */
		medicine_power(40).
		medicine_list([
			[2,3],[8,4],[10,6],
			[6,8],[9,10],[3,11],
			[5,15],[9,15],[2,20]
			]).
		set_medicines(Medicines) :-
			retract(medicine_list(_)),
			asserta(medicine_list(Medicines)).
		medicine_point(Medicine, X, Y) :-
			nth0(0, Medicine, X),
			nth0(1, Medicine, Y).
		put_medicines :-
			medicine_list(Medicines),
			put_medicines(Medicines).
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

	/* Weapon Object */
		weapon_list([
			['kertas ridus', 10, [5,1]],
			['kertas rius', 20, [1,3]],
			['kertas risaikel', 30, [5,8]],
			['kerang ajaib', 40, [7,10]],
			['tabel parser', 50, [6,12]],
			['sepuluh tubes', 60, [9,16]],
			['sepanci micin', 70, [10,19]],
			['buku kalkulus', 80, [8,20]],
			['tiang listrik', 90, [1,20]]
			]).
		weapon(Name, Weapon) :-
			weapon_list(Weapons),
			weapon(Weapons, Name, Weapon).
		weapon([W|Weapons], Name, W) :- !.
		weapon([], Name, W) :- !, fail.
		weapon([W|Weapons], Name, Weapon) :-
			weapon_name(W, NameW),
			NameW == NameWeapon,
			weapon([W|Weapons], Name, W),
			!.
		weapon([W|Weapons], Name, Weapon) :-
			weapon(Weapons, Name, Weapon).
		set_weapons(Weapons) :-
			retract(weapon_list(_)),
			asserta(weapon_list(Weapons)).
		weapon_name(Weapon, Name) :-
			nth0(0, Weapon, Name).
		weapon_point(Weapon, Point) :-
			nth0(2, Weapon, Point).
		weapon_damage(Weapon, Damage) :-
			nth0(1, Weapon, Damage).
		put_weapons :- 
			weapon_list(Weapons),
			put_weapons(Weapons).
		put_weapons([]) :- !.
		put_weapons([W|Weapons]) :-
			weapon_point(W,Point),
			Point = [X,Y],
			set_map_el(X, Y, '#'),
			put_weapons(Weapons).
		is_player_on_weapon([]) :- !, fail.
		is_player_on_weapon([Weapon|_]) :-
			player_point(PRow, PColumn),
			weapon_point(Weapon, Point),
			Point = [Row,Column],
			is_coor_equal([PRow,PColumn],[Row,Column]), 
			!.
		is_player_on_weapon([_|Weapons]) :-
			is_player_on_weapon(Weapons).
		status_weapon(Weapon) :-
			nl,
			weapon_damage(Weapon, Damage),
			write(Damage),
			write(' Damage\n').

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
		put_holes :-
			hole_list(Holes),
			put_holes(Holes).
		put_holes([]) :- !.
		put_holes([H|Holes]) :-
			hole_point(H, X, Y),
			set_map_el(X, Y, 'X'),
			put_holes(Holes).
		is_object_on_hole(Point) :-
			hole_list(Holes),
			is_object_on_hole(Holes, Point), !.
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
			init_enemy(N, DRow, DColumn, Enemy, Enemies).
		init_enemy(N, Row, Column, Enemy, Enemies) :-
			enemy(N, DEnemy),
			change(DEnemy, 4, [Row,Column], Enemy).

		/* Avoid same enemies location when initialization */ 
		invalidate_init_pos(Point, []) :-
			is_object_on_hole(Point).
		invalidate_init_pos(Point, [Enemy|EnemyList]) :-
			enemy_point(Enemy, EnemyPoint),
			is_coor_equal(Point, EnemyPoint),
			nl,
			!.
		invalidate_init_pos(Point, [Enemy|EnemyList]) :-
			invalidate_init_pos(Point, EnemyList).
		/* Avoid enemy move to hole or boundaries */
		validate_pos(X, Y) :-
			X >= 1, X =< 10,
			Y >= 1, Y =< 20,
			\+is_object_on_hole([X,Y]).
		put_enemies :-
			enemy_list(Enemies),
			put_enemies(Enemies).
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
			!,
			attack_player(E),
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
		take_item(Item, Type) :-
			Type == 'F',
			write('Food has been taken.'),
			nl,
			fail.
		take_item(Item, Type) :-
			Type == 'W',
			write('Water has been taken.'),
			nl,
			fail.
		take_item(Item, Type) :-
			Type == '#',
			write('Weapon has been taken.'),
			nl,
			fail.
		take_item(Item, Type) :-
			player_inventory(Inventory),	
			player_capacity(Capacity),
			length(Inventory, Len),
			Len < Capacity,
			set_player_inventory([Item|Inventory]),
			!.
		take_item(Item) :-
			write('Your inventory is full.\n').
		validate_player :-
			player_health(Health),
			Health =< 0,
			set_state(2).
		validate_player.
		validate_player_pos(Point) :-
			is_object_on_hole(Point),
			set_player_health(0),
			set_state(2).
		validate_player_pos(Point).
		status_inventory([]) :- !.
		status_inventory([Item|Inventory]) :-
			write(Item), write(' '),
			status_inventory(Inventory).
		drop_item(Item, Point, 'F') :-
			food_list(Foods),
			append([[Point]], Foods, List),
			set_foods(List),
			nth0(0, Item, Name),
			write(Name),
			write(' has been dropped'),
			nl.
		drop_item(Item, Point, 'W') :-
			water_list(Water),
			append([[Point]], Water, List),
			set_water(List),
			nth0(0, Item, Name),
			write(Name),
			write(' has been dropped.'),
			nl.
		drop_item(Item, Point, 'M') :-
			medicine_list(Medicines),
			append([[Point]], Medicines, List),
			set_medicines(List),
			nth0(0, Item, Name),
			write(Name),
			write(' has been dropped.'),
			nl.
		drop_item(Item, Point, '#') :-
			weapon_list(Weapons),
			weapon_name(Item, Name),
			weapon_damage(Item, Damage),
			append([[Name, Damage, Point]], Weapons, List),
			set_weapons(List),
			nth0(0, Item, Name),
			write(Name),
			write(' has been dropped.'),
			nl.
		use_item(Item, '#') :-
			player_weapon(CurrentWeapon),
			add_inventory(CurrentWeapon),
			set_player_weapon(Item),
			nth0(0, Item, Name),
			nth0(1, Item, Damage),
			write(Name), write(' is used.'), nl,
			write('Current damage is '), write(Damage), nl.
		use_item(Item, 'M') :-
			medicine_power(Power),
			player_health(CurrentHealth),
			Health is Power+CurrentHealth,
			set_player_health(Health),
			write('Increased health by '),
			write(Power),
			nl.
		use_item(Item, 'W') :-
			water_power(Power),
			player_thirst(CurrentThirst),
			Thirst is Power+CurrentThirst,
			set_player_thirst(Thirst),
			write('Increased thirst by '),
			write(Power),
			nl.
		use_item(Item, 'F') :-
			food_power(Power),
			player_hunger(CurrentHunger),
			Hunger is Power+CurrentHunger,
			set_player_hunger(Hunger),
			write('Increased hunger by '),
			write(Power),
			nl,
			!.
		search_inventory(Name, Item) :-
			player_inventory(Inventory),
			search_inventory(Name, Inventory).
		search_inventory(Name, [], Item) :- !, fail.
		search_inventory(Name, [Item|Inventory], Item) :- !.
		search_inventory(Name, [Search|Inventory], Item) :-
			nth0(0, Search, NameItem),
			Name == NameItem, 
			search_inventory(Name, [Search|Inventory], Search).
		search_inventory(Name, [Search|Inventory], Item) :-
			search_inventory(Name, Inventory, Item).
		add_inventory(Item) :-
			player_inventory(Inventory),
			set_player_inventory(Item, [Item|Inventory]).
		del_inventory(Item) :-
			player_inventory(Inventory),
			del_inventory(Item, Inventory, NewInventory).
		del_inventory(Item, [Item|Inventory], Inventory) :- !.
		del_inventory(Item, [Search|Inventory], NewInventory) :-
			del_inventory(Item, Inventory, [Search|NewInventory]).

/*Command-Command utama*/
	start:- 
		validate_stop,
		set_state(1),
		set_player_point(1,1),
		init_enemies(10).
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
		redraw_look,
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
		set_player_point(Brs, Column),
		validate_player_pos([Brs, Column]).
	n :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Row > 1,
		Brs is Row-1,
		set_player_point(Brs, Column),
		validate_player_pos([Brs, Column]).
	e :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Column < 20,
		Kol is Column+1,
		set_player_point(Row, Kol),
		validate_player_pos([Brs, Column]).
	w :- 
		validate_running,
		trigger_enemy,
		player_point(Row,Column),
		Column > 1,
		Kol is Column-1,
		set_player_point(Row, Kol),
		validate_player_pos([Brs, Column]).
	map :- 
		validate_running,
		redraw_map,
		peta(M), 
		print_matriks(M), !.
	take(Name) :-
		validate_running,
		trigger_enemy,
		fail.
	take(Name) :-
		validate_running,
		search_object(Name, Item, Type),
		object_point(Item, Type, Point),
		player_point(PlayerPoint),
		is_coor_equal(Point, PlayerPoint), 
		del_object(Item, Type),
		format_item(Item, Type, FItem),
		take_item(FItem).
	take(Object) :-
		validate_running,
		write('No item found.\n').
	use(Name) :-
		validate_running,
		trigger_enemy,
		search_inventory(Name, Item),
		del_inventory(Item),
		nth0(2, Item, Symbol),
		use_item(Item, Symbol), !.
	use(Name) :-
		write('Not found in inventory'), nl.
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
		fail.
	drop(Name) :-
		search_inventory(Name, Item),
		del_inventory(Item),
		player_point(Point),
		drop_item(Item, Point, Type).
	drop(Name) :-
		write('Not found in your inventory.'),
		nl.
	attack:- 
		player_weapon([Name,_]),
		Name \== "-",
		enemy_atacked(enemy_list),
		!.
	attack:- 
		write('Salah Blog\n'),
		!,
		fail.
