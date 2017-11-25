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
:- dynamic(radar/1).
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
		/* Retracting all fact */
		retract_all :-
			retract(peta(_)),
			fail.
		retract_all :-
			retract(baris(_, _)),
			fail.
		retract_all :-
			retract(player_health(_)),
			fail.
		retract_all :-
			retract(player_hunger(_)),
			fail.
		retract_all :-
			retract(player_point(_, _)),
			fail.
		retract_all :-
			retract(player_inventory(_)),
			fail.
		retract_all :-
			retract(player_weapon(_)),
			fail.
		retract_all :-
			retract(enemy_list(_)),
			fail.
		retract_all :-
			retract(enemy_point(_, _)),
			fail.
		retract_all :-
			retract(weapon_list(_)),
			fail.
		retract_all :-
			retract(water_list(_)),
			fail.
		retract_all :-
			retract(food_list(_)),
			fail.
		retract_all :-
			retract(medicine_list(_)),
			fail.
		retract_all :-
			retract(game_state(_)),
			fail.
		retract_all.
		/* Universal object searhing */
		search_object(Name, Item, 'F') :-
			food_list(Foods),
			search_object_list(Name, Foods, Item), !.
		search_object(Name, Item, 'W') :-
			water_list(Water),
			search_object_list(Name, Water, Item), !.
		search_object(Name, Item, 'M') :-
			medicine_list(Medicines),
			search_object_list(Name, Medicines, Item), !.
		search_object(Name, Item, '#') :-
			weapon_list(Weapons),
			search_object_list(Name, Weapons, Item), !.
		search_object(Name, Item, 'R') :-
			radar(Radars),
			search_object_list(Name, Radars, Item).
		search_object_list(0, [Item|List], Item) :- !.
		search_object_list(Name, [], Item) :- !, fail.
		search_object_list(Name, [Search|List], Item) :-
			nth0(0, Search, NameItem),
			Name == NameItem,
			search_object_list(0, [Search|List], Item), !.
		search_object_list(Name, [_|List], Item) :-
			search_object_list(Name, List, Item).
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
		del_object(Object, 'R') :-
			radar(Radars),
			select(Object, Radars, List),
			set_radar(List).
		format_item(Item, Type, [Name, Power, Type]) :-
			object_name(Item, Name),
			object_effect(Item, Power).
		/* True when two points is same */
		is_coor_equal([],[]).
		is_coor_equal([X|P1], [X|P2]) :-
			is_coor_equal(P1,P2).	
		/* State Validation */
		validate_running :-
			game_state(0),
			write('Game is not started yet.'), !, fail.
		validate_running :-
			game_state(2),
			write('Game is Over. You died.'), !, fail.
		validate_running.
		validate_stop :-
			game_state(1),
			write('Game has been started.'), !, fail.
		validate_stop.
		validate_quit :-
			game_state(0),
			write('Game is not started yet.'), !, fail.
		validate_quit.
		/* Messages */
		start_message :- 
			write('Welcome to the 77th Hunger Games!'), nl, nl,
			write('You have been chosen as one of the lucky contestants.'), nl,
			write('Be the last man standing and you will be remembered as one of the victors.'), nl, nl,
			write('Legends:'), nl,
			write('M = medicine F = food'), nl,
			write('W = water'), nl,
			write('# = weapon P = player E = enemy'), nl, 
			write('- = accessible'), nl,
			write('X = inaccessible'), nl, nl,
			write('Happy Hunger Games!'), nl,
			write('And may the odds be ever in your favor.'), nl, nl.
		/* Print object which has same point with player */
		print_object_on_player :-
			food_list(Foods),
			print_object_on_player(Foods),
			medicine_list(Medicines),
			print_object_on_player(Medicines),
			water_list(Water),
			print_object_on_player(Water),
			weapon_list(Weapons),
			print_object_on_player(Weapons),
			enemy_list(Enemies),
			print_enemy_on_player(Enemies),
			radar(Radars),
			print_object_on_player(Radars),
			fail.
		print_object_on_player.
		print_object_on_player([]) :- !.
		print_object_on_player([Object|_]) :-
			object_point(Object, Point),
			player_point(Row, Column),
			is_coor_equal(Point, [Row, Column]),
			object_name(Object, Name),
			object_effect(Object, Effect),
			write(Name), write(' | '), write('Effect: '), write(Effect), nl,
			fail.
		print_object_on_player([_|List]) :-
			print_object_on_player(List).
		print_enemy_on_player([]) :- !.
		print_enemy_on_player([Enemy|Enemies]) :-
			enemy_point(Enemy, Point),
			player_point(Row, Column),
			is_coor_equal(Point, [Row, Column]),
			enemy_name(Enemy, Name),
			enemy_health(Enemy, Health),
			write(Name), write(' | '), write('Health: '), write(Health), nl,
			fail.
		print_enemy_on_player([_|Enemies]) :-
			print_enemy_on_player(Enemies).
		/* Universal Getter Point */
		object_point(Object, Point) :-
			nth0(2, Object, Point).
		object_effect(Object, Effect) :-
			nth0(1, Object, Effect).
		object_name(Object, Name) :-
			nth0(0, Object, Name).

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
		retract(peta(_)),
		fail.
	init_map:-
		create_map(12,M),
		asserta(peta(M)),!.
	/*Update Peta setelah terjadi perubahan*/
	update_map :-  
		create_map(12,M),
		retract(peta(_)),
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
		put_radar,
		put_enemies.
	redraw_look :-
		reset_row(1, 11),
		put_holes,
		put_player,
		put_weapons,
		put_water,
		put_foods,
		put_medicines,
		put_radar,
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
	print_where :- 
		player_point(X,Y),
		X =< 3,
		Y =< 5,
		print('You are in Siliwangi Jungle '),
		!.
	print_where :- 
		player_point(X,Y),
		X =< 3,
		Y > 5 ,
		print('You are in East Far'),
		!.
	print_where :- 
		player_point(X,Y),
		X > 3,
		X =< 7,
		Y =< 7,
		print('You are in Telemountain'),
		!.
	print_where :- 
		player_point(X,Y),
		X > 3,
		X =< 7,
		Y > 7,
		print('you are in Electric Field'),
		!.
	print_where :- 
		player_point(X,Y),
		X > 7,
		Y =< 15,
		print('You are in Friendzone Town'),
		!.
	print_where :- 
		player_point(X,Y),
		X > 7,
		Y =< 15,
		print('You are in Corruptor Camp'),
		!.
/* Primitif Object Game */
	/* Food Object */
		food_power(30).
		food_list([
			['korea rice', 30, [3,1]],
			['japan rice', 30, [7,1]],
			['apple', 30, [8,1]],
			['dragon egg', 30, [5,5]],
			['kuro-kuro', 30, [5,7]],
			['potato', 30, [3,8]],
			['hambagu', 30, [2,10]],
			['spaghetti', 30, [5,11]],
			['lasagna', 30, [8,11]],
			['dragon egg', 30, [7,14]],
			['kuro-kuro', 30, [4,14]],
			['mushroom', 30, [2,15]],
			['apple', 30, [4,17]],
			['japan rice', 30, [8,19]],
			['korean rice', 30, [5,20]],
			['hambagu', 30, [6,20]]
			]).
		set_foods(Foods) :-
			retract(food_list(_)),
			asserta(food_list(Foods)).
		food_point(Food, Point) :-
			nth0(2, Food, Point).
		food_point(Food, X, Y) :-
			food_point(Food, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		put_foods :-
			food_list(Foods),
			put_foods(Foods).
		food_name(Food, Name):-
			nth0(0,Food, Name).
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
			['holy water', 30, [3,2]],
			['mineral water', 30, [9,1]],
			['kangen water', 30, [2,5]],
			['mineral water', 30, [6,7]],
			['kangen water', 30, [8,10]],
			['kangen water', 30, [4,12]],
			['healty water', 30, [5,12]],
			['lake water', 30, [4,13]],
			['holy water', 30, [5,13]],
			['holy water', 30, [2,17]],
			['mineral water', 30, [7,19]],
			['healthy water', 30, [7,20]]
			]).
		set_water(Water) :-
			retract(water_list(_)),
			asserta(water_list(Water)).
		water_point(Water, Point) :-
			nth0(2, Water, Point).
		water_point(Water, X, Y) :-
			water_point(Water, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		water_name(Water, Name) :-
			nth0(0, Water, Name).
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
			['panadol', 40, [2,3]],
			['betadine', 40, [8,4]],
			['oskadon', 40, [10,6]],
			['anti-biotic', 40, [6,8]],
			['paracetamol', 40, [9,10]],
			['madu rasa', 40, [3,11]],
			['panadol', 40, [5,15]],
			['oskadon', 40, [9,15]],
			['tango', 40, [2,20]]
			]).
		set_medicines(Medicines) :-
			retract(medicine_list(_)),
			asserta(medicine_list(Medicines)).
		medicine_point(Medicine, Point) :-
			nth0(2, Medicine, Point).
		medicine_point(Medicine, X, Y) :-
			medicine_point(Medicine, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		medicine_name(Medicine, Name) :-
			nth0(0, Medicine, Name).
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

	/* Radar Object */
		radar([
			['radar', 'reveal enemies position', [0,0]]
			]).
		set_radar(Radar) :-
			retract(radar(_)),
			asserta(radar(Radar)).
		radar_point(Radar, X, Y) :-
			nth0(2, Radar, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		radar_name(Radar,Name):-
			nth0(0,Radar,Name).
		put_radar :-
			radar(Radars),
			put_radar(Radars).
		put_radar([]) :- !.
		put_radar([Radar|List]) :-
			radar_point(Radar, X, Y),
			set_map_el(X, Y, 'R').
		is_player_on_radar([]) :- !, fail.
		is_player_on_radar([Radar|_]) :-
			player_point(PRow, PColumn),
			radar_point(Radar, Row, Column),
			is_coor_equal([PRow,PColumn],[Row,Column]), !.
		is_player_on_radar([_|Radar]) :-
			is_player_on_radar(Radar).
		init_radar :-
			random(1, 10, Row),
			random(1, 20, Column),
			\+is_object_on_hole([Row, Column]),
			set_radar([
				['radar', 0, [Row, Column]]
				]), !.
		init_radar :-
			init_radar.

	/* Weapon Object */
		weapon_list([
			['kertas ridus', 10, [5,1]],
			['kertas rius', 20, [1,3]],
			['kanya', 30, [5,8]],
			['yasha', 40, [7,10]],
			['micin panas', 50, [6,12]],
			['axe of toobes', 60, [9,16]],
			['trisula of poseidon', 70, [10,19]],
			['book of sadiku', 80, [8,20]],
			['tiang listrik', 90, [1,20]]
			]).
		weapon(Name, Weapon) :-
			weapon_list(Weapons),
			weapon(Weapons, Name, Weapon).
		weapon([W|_], _, W) :- !.
		weapon([], _, _) :- !, fail.
		weapon([W|Weapons], Name, _) :-
			weapon_name(W, NameW),
			NameW == Name,
			weapon([W|Weapons], Name, W),
			!.
		weapon([_|Weapons], Name, Weapon) :-
			weapon(Weapons, Name, Weapon).
		set_weapons(Weapons) :-
			retract(weapon_list(_)),
			asserta(weapon_list(Weapons)).
		weapon_name(Weapon, Name) :-
			nth0(0, Weapon, Name).
		weapon_point(Weapon, Point) :-
			nth0(2, Weapon, Point).
		weapon_point(Weapon, Row, Column) :-
			weapon_point(Weapon, Point),
			nth0(0, Point, Row),
			nth0(1, Point, Column).
		weapon_damage(Weapon, Damage) :-
			nth0(1, Weapon, Damage).
		put_weapons :- 
			weapon_list(Weapons),
			put_weapons(Weapons).
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
			is_object_on_hole(Holes, Point).
		is_object_on_hole([], _) :- !, fail.
		is_object_on_hole([Hole|_], Point) :-
			hole_point(Hole, Row, Column),
			is_coor_equal(Point,[Row,Column]), 
			!.
		is_object_on_hole([_|Holes], Point) :-
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
			enemy_name(Enemy, _),
			!.
		set_enemy(Enemy, [E|Enemies],Res) :-
			enemy_id(Enemy, Id),
			enemy_id(E, EId),
			Id \== EId,
			set_enemy(Enemy,Enemies,DRes),
			append([E],DRes,Res).
		set_point(Enemy, Point, DEnemy) :-
			change(Enemy, 4, Point, DEnemy).
		enemy_point(Enemy, X, Y) :-
			enemy_point(Enemy, Point),
			nth0(0, Point, X),
			nth0(1, Point, Y).
		enemy_name(Enemy, Name) :-
			nth0(0, Enemy, Name).
		enemy_health(Enemy, Health) :-
			nth0(1, Enemy, Health).
		enemy_damage(Enemy, Damage) :-
			nth0(2, Enemy, Damage).
		enemy_point(Enemy, Point) :-
			nth0(3, Enemy, Point).
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
		enemy_atacked([_|Rest]):-
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
		init_enemy(N, Row, Column, Enemy, _) :-
			enemy(N, DEnemy),
			change(DEnemy, 4, [Row,Column], Enemy).

		/* Avoid same enemies location when initialization */ 
		invalidate_init_pos(Point, []) :-
			is_object_on_hole(Point).
		invalidate_init_pos(Point, [Enemy|_]) :-
			enemy_point(Enemy, EnemyPoint),
			is_coor_equal(Point, EnemyPoint),
			nl,
			!.
		invalidate_init_pos(Point, [_|EnemyList]) :-
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
			length(Enemies, _),
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
			write('Damaged '), 
			write(Damage),
			write(' Points | Current Health '),
			write(Health),
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
		player_weapon([0, 0, 0]).
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
		take_item(_, 'F') :-
			write('Food has been taken.'),
			nl,
			fail.
		take_item(_, 'W') :-
			write('Water has been taken.'),
			nl,
			fail.
		take_item(_, '#') :-
			write('Weapon has been taken.'),
			nl,
			fail.
		take_item(_, 'M') :-
			write('Medicine has been taken.'),
			nl,
			fail.
		take_item(Item, 'R') :-
			write('Radar has been taken.'),
			nl,
			fail.
		take_item(Item, _) :-
			player_inventory(Inventory),	
			player_capacity(Capacity),
			length(Inventory, Len),
			Len < Capacity,
			set_player_inventory([Item|Inventory]),
			!.
		take_item(_, _) :-
			write('Your inventory is full.\n').
		validate_player :-
			player_health(Health),
			Health =< 0,
			set_state(2).
		validate_player.
		validate_player_pos(Point) :-
			is_object_on_hole(Point),
			!,
			set_player_health(0),
			set_state(2),
			write('You fell into a hole.'), nl.
		validate_player_pos(_).
		status_inventory([]) :- !.
		status_inventory([Object|Inventory]) :-
			Object = [ItemName|_],
			write(ItemName), write(' | '),
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
		drop_item(Item, Point, 'R') :-
			radar(Radars),
			append([['radar', 'reveal enemies position', Point]], Radars, List),
			set_radar(List),
			write('radar has been dropped.'),
			nl.
		use_item(Item, '#') :-
			player_weapon(CurrentWeapon),
			add_inventory(CurrentWeapon),
			set_player_weapon(Item),
			nth0(0, Item, Name),
			nth0(1, Item, Damage),
			write(Name), write(' is used.'), nl,
			write('Current damage is '), write(Damage), nl.
		use_item(_, 'M') :-
			medicine_power(Power),
			player_health(CurrentHealth),
			Health is Power+CurrentHealth,
			set_player_health(Health),
			write('Increased health by '),
			write(Power),
			nl.
		use_item(_, 'W') :-
			water_power(Power),
			player_thirst(CurrentThirst),
			Thirst is Power+CurrentThirst,
			set_player_thirst(Thirst),
			write('Increased thirst by '),
			write(Power),
			nl.
		use_item(_, 'F') :-
			food_power(Power),
			player_hunger(CurrentHunger),
			Hunger is Power+CurrentHunger,
			set_player_hunger(Hunger),
			write('Increased hunger by '),
			write(Power),
			nl,
			!.
		item_type(Item, Type) :-
			nth0(2, Item, Type).
		search_inventory(Name, Item) :-
			player_inventory(Inventory),
			search_inventory(Name, Inventory, Item).
		search_inventory(_, [], _) :- !, fail.
		search_inventory(0, [Item|_], Item) :- !.
		search_inventory(Name, [Search|Inventory], Item) :-
			nth0(0, Search, NameItem),
			Name == NameItem, 
			search_inventory(0, [Search|Inventory], Item).
		search_inventory(Name, [_|Inventory], Item) :-
			search_inventory(Name, Inventory, Item).
		add_inventory(Item) :-
			nth0(0, Item, Name),
			Name \== 0,
			player_inventory(Inventory),
			set_player_inventory([Item|Inventory]).
		add_inventory(_).
		del_inventory(Item) :-
			player_inventory(Inventory),
			del_inventory(Item, Inventory, NewInventory),
			set_player_inventory(NewInventory).
		del_inventory(Item, [Item|Inventory], Inventory) :- !.
		del_inventory(Item, [Search|Inventory], NewInventory) :-
			del_inventory(Item, Inventory, [Search|NewInventory]).
		attack_enemy(Enemies, Damage) :-
			attack_enemy(Enemies, Damage, 0).
		attack_enemy([], Damage, Number) :-Number > 0, !.
		attack_enemy([], Damage, 0) :- !, fail.
		attack_enemy([Enemy|Enemies], Damage, Number) :-
			enemy_point(Enemy, Point),
			player_point(Row, Column),
			is_coor_equal(Point, [Row, Column]),
			enemy_health(Enemy, Health),
			CurrentHealth is Health-Damage,
			CurrentNumber is Number+1,
			change(Enemy, 1, CurrentHealth, CurrentEnemy),
			set_enemy(Enemy),
			enemy_name(Enemy, Name),
			write(Name),
			write(' current health is '),
			write(CurrentHealth),
			nl,
			attack_enemy(Enemies, Damage, CurrentNumber),
			!.
		attack_enemy([Enemy|Enemies], Damage, Number) :-
			attack_enemy(Enemies, Damage, Number).

/*Command-Command utama*/
	start :- 
		validate_stop,
		start_message,
		help,
		set_state(1),
		set_player_point(1,1),
		init_radar,
		init_enemies(10),
		read_command.
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
		!,
		player_point(Row,Column),
		MinBrs is Row-1 ,
		MaxBrs is Row+1 , 
		MinKol is Column-1 ,
		MaxKol is Column+1 , 
		print_batas_mapk(MinBrs,MaxBrs,MinKol,MaxKol),
		nl,
		write('Close Object:'),
		nl,
		print_object_on_player,
		nl,
		print_where.
	s :- 
		validate_running,
		trigger_enemy,
		!,
		player_point(Row,Column),
		Row < 10,
		Brs is Row+1,
		set_player_point(Brs, Column),
		!,
		validate_player_pos([Brs, Column]),
		write('You are going to South ! '),
		print_where.
	n :- 
		validate_running,
		trigger_enemy,
		!,
		player_point(Row,Column),
		Row > 1,
		Brs is Row-1,
		set_player_point(Brs, Column),
		!,
		validate_player_pos([Brs, Column]),
		write('You are going to North ! '),
		print_where.
	e :- 
		validate_running,
		trigger_enemy,
		!,
		player_point(Row,Column),
		Column < 20,
		Kol is Column+1,
		set_player_point(Row, Kol),
		!,
		validate_player_pos([Row, Kol]),
		write('You are going to East ! '),
		print_where.
	w :- 
		validate_running,
		trigger_enemy,
		!,
		player_point(Row,Column),
		Column > 1,
		Kol is Column-1,
		set_player_point(Row, Kol),
		!,
		validate_player_pos([Row, Kol]),
		write('You are going to West ! '),
		print_where.
	map :- 
		validate_running, fail.
	map :-
		game_state(1),
		search_inventory('radar', Item),
		redraw_map,
		init_radar,
		peta(M), 
		print_matriks(M), !.
	map :-
		game_state(1),
		write('You have no radar in inventory'),
		nl.
	take(_) :-
		validate_running,
		trigger_enemy,
		fail.
	take(Name) :-
		validate_running,
		player_point(PRow, PCol),
		search_object(Name, Item, Type),
		object_point(Item, Point),
		is_coor_equal(Point, [PRow, PCol]), 
		del_object(Item, Type),
		format_item(Item, Type, FItem),
		take_item(FItem, Type), !.
	take(_) :-
		validate_running,
		write('No item found.\n').
	use(Name) :-
		validate_running,
		trigger_enemy,
		search_inventory(Name, Item),
		del_inventory(Item),
		nth0(2, Item, Symbol),
		use_item(Item, Symbol), !.
	use(_) :-
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
		write('Weapon    : '), status_weapon(Weapon),
		write('Inventory : '), status_inventory(Inventory), nl.
	drop(_) :-
		validate_running,
		trigger_enemy,
		fail.
	drop(Name) :-
		search_inventory(Name, Item),
		item_type(Item, Type),
		del_inventory(Item),
		player_point(Row, Column),
		drop_item(Item, [Row, Column], Type).
	drop(_) :-
		write('Not found in your inventory.'),
		nl.
	attack:- 
		player_weapon(Weapon),
		weapon_damage(Weapon, Damage),
		enemy_list(Enemies),
		attack_enemy(Enemies, Damage),
		write('Attacking all enemies by '),
		write(Damage),
		write(' damage.'),
		nl,
		!.
	attack:- 
		write('Attacking nobody.'), nl.
	/* Save and Load Game */
		save(F) :-
			telling(V), tell(F),
			listing(peta/1),
			listing(baris/2),
			listing(player_health/1),
			listing(player_hunger/1),
			listing(player_point/2),
			listing(player_inventory/1),
			listing(player_weapon/1),
			listing(enemy_list/1),
			listing(enemy_point/2),
			listing(weapon_list/1),
			listing(water_list/1),
			listing(food_list/1),
			listing(medicine_list/1),
			listing(game_state/1),
			told, tell(V).
		aload(F) :-
			retract_all,
			seeing(V), see(F),
			repeat,
			read(Data),
			process(Data),
			seen,
			see(V),
			!.
		process(end_of_file) :- !.
		process(Data) :- 
			asserta(Data), 
			fail.
	/* Looping */
	read_command :-
		game_state(1), 
		nl,
		write(>),
		read(X) , 
		kasus(X) ,
		!.
	read_command :-
		!,
		fail.
	kasus(X) :-
		X \== quit , 
		X , 
		read_command .
	kasus(X) :- 
		X == quit , 
		set_state(0),
		!.
	kasus(_) :- 
		read_command.