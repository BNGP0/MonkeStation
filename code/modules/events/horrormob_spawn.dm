// basically a portal storm, but has no announcement and spawns mobs in public areas only
/datum/round_event_control/hm_spawn_eye_statues
	name = "Portal Storm: Eye statues"
	typepath = /datum/round_event/hm_spawn/eye_statues
	weight = 20
	min_players = 0
	earliest_start = 2 MINUTES
	max_occurrences = 2

/datum/round_event/hm_spawn/eye_statues
	hostile_types = list(/mob/living/simple_animal/hostile/statue/eyes = 4)


/datum/round_event_control/hm_spawn_hermits
	name = "Portal Storm: Locker Hermits"
	typepath = /datum/round_event/hm_spawn/hermits
	weight = 15
	min_players = 0
	earliest_start = 2 MINUTES
	max_occurrences = 3

/datum/round_event/hm_spawn/hermits
	hostile_types = list(/mob/living/simple_animal/hostile/horrormob/hermit = 12)
// horrorstation end


/datum/round_event/hm_spawn
	startWhen = 7
	endWhen = 999
	announceWhen = 1

	var/list/boss_spawn = list()
	var/list/boss_types = list() //only configure this if you have hostiles
	var/number_of_bosses
	var/next_boss_spawn
	var/list/hostiles_spawn = list()
	var/list/hostile_types = list()
	var/number_of_hostiles
	var/mutable_appearance/storm

/datum/round_event/hm_spawn/setup()
	storm = mutable_appearance('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", FLY_LAYER)
	storm.color = "#00FF00"

	number_of_bosses = 0
	for(var/boss in boss_types)
		number_of_bosses += boss_types[boss]

	number_of_hostiles = 0
	for(var/hostile in hostile_types)
		number_of_hostiles += hostile_types[hostile]

	while(number_of_bosses > boss_spawn.len)
		boss_spawn += get_random_station_turf()

	while(number_of_hostiles > hostiles_spawn.len)
		hostiles_spawn += get_random_station_turf()

	next_boss_spawn = startWhen + CEILING(2 * number_of_hostiles / number_of_bosses, 1)
/*
/datum/round_event/portal_storm/announce(fake)
	set waitfor = 0
	sound_to_playing_players('sound/magic/lightning_chargeup.ogg')
	sleep(80)
	priority_announce("Massive bluespace anomaly detected en route to [station_name()]. Brace for impact.", sound = SSstation.announcer.get_rand_alert_sound())
	sleep(20)
	sound_to_playing_players('sound/magic/lightningbolt.ogg')
*/
/datum/round_event/hm_spawn/tick()
	spawn_effects(get_random_station_turf())

	if(spawn_hostile())
		var/type = safepick(hostile_types)
		hostile_types[type] = hostile_types[type] - 1
		spawn_mob(type, hostiles_spawn)
		if(!hostile_types[type])
			hostile_types -= type

	if(spawn_boss())
		var/type = safepick(boss_types)
		boss_types[type] = boss_types[type] - 1
		spawn_mob(type, boss_spawn)
		if(!boss_types[type])
			boss_types -= type

	time_to_end()
///////////////////////////////////////////// mob spawn
/datum/round_event/hm_spawn/proc/spawn_mob(type, spawn_list)
	if(!type)
		return
//	var/turf/T = pick_n_take(spawn_list)
	var area/thearea = pickweight(GLOB.publicteleportlocs)

	for(var/turf/T in get_area_turfs(thearea.type))
		if(!T.density)
			var/clear = TRUE
			for(var/obj/O in T)
				if(O.density)
					clear = FALSE
					break
			if(clear)
				L+=T

		if(!L.len)
			return
// // //
	if(!T)
		return
	new type(T)
	spawn_effects(T)

/datum/round_event/hm_spawn/proc/spawn_effects(turf/T)
	if(!T)
		log_game("Horrormob spawn event failed to spawn effect due to an invalid location.")
		return
	T = get_step(T, SOUTHWEST) //align center of image with turf
	flick_overlay_static(storm, T, 15)
	playsound(T, 'sound/magic/lightningbolt.ogg', rand(80, 100), 1)

/datum/round_event/hm_spawn/proc/spawn_hostile()
	if(!hostile_types || !hostile_types.len)
		return 0
	return ISMULTIPLE(activeFor, 2)

/datum/round_event/hm_spawn/proc/spawn_boss()
	if(!boss_types || !boss_types.len)
		return 0

	if(activeFor == next_boss_spawn)
		next_boss_spawn += CEILING(number_of_hostiles / number_of_bosses, 1)
		return 1

/datum/round_event/hm_spawn/proc/time_to_end()
	if(!hostile_types.len && !boss_types.len)
		endWhen = activeFor

	if(!number_of_hostiles && number_of_bosses)
		endWhen = activeFor
