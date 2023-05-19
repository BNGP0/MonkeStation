
/mob/living/simple_animal/hostile/horrormob
	name = "Debug horrormob"
	desc = "You should shit yourself NOW!"


// copypasted from  statue code
/mob/living/simple_animal/hostile/horrormob/proc/can_be_seen(turf/destination)
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null
	var/list/check_list = list(src)
	if(destination)
		check_list += destination
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(getexpandedview(world.view, 1, 1), check))
			if(M != src && M.client && CanAttack(M) && !M.has_unlimited_silicon_privilege && !M.eye_blind)
				return M
		for(var/obj/mecha/M in view(getexpandedview(world.view, 1, 1), check)) //assuming if you can see them they can see you
			if(M.occupant?.client && !M.occupant.eye_blind)
				return M.occupant
	return null

/mob/living/simple_animal/hostile/horrormob/FindHidden()
	return 0 // So most horror mobs don't search for people in lockers



// i used collosus code as a template, so there may be some leftover megafauna code and some errors related to it
/mob/living/simple_animal/hostile/horrormob/blink
	name = "Blink"
	desc = ""
	health = 180 // to create an illusion that it can be damaged and doesn't teleport away faster than you can reach your gun
	maxHealth = 250
	attacktext = "judges"
	attack_sound = 'sound/magic/clockwork/ratvar_attack.ogg'
	icon_state = "blink"
	icon_living = "blink"
	icon_dead = ""
	icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	speak_emote = list("roars")
	armour_penetration = 10
	melee_damage = 30
	speed = 10
	move_to_delay = 1
	pixel_x = -32
	del_on_death = TRUE
	deathmessage = "disintegrates."
	deathsound = 'sound/magic/demon_dies.ogg'
	search_objects = 1
	wanted_objects = list(/obj/machinery/light)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

/mob/living/simple_animal/hostile/horrormob/blink/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		disappear()
		return 0
	return ..()

/mob/living/simple_animal/hostile/horrormob/blink/proc/disappear()
	src.icon_state = "blink_disappearing"
	src.icon_living = "blink_disappearing"
	sleep(6)
	var/turf/safe_turf = find_safe_turf(zlevels = src.z, extended_safety_checks = TRUE)
	do_teleport(src,safe_turf,channel = TELEPORT_CHANNEL_MAGIC)
	sleep(4)
	src.icon_state = "blink"
	src.icon_living = "blink"

///mob/living/simple_animal/hostile/horrormob/blink/ObjBump(obj/O)
//	return //


/mob/living/simple_animal/hostile/horrormob/hermit
	name = "Hermit"
	desc = ""
	health = 100
	maxHealth = 100
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	icon_state = "locker_hermit"
	icon_living = "locker_hermit"
	icon_dead = "locker_hermit"
	speak_emote = list("roars")
	armour_penetration = 5
	melee_damage = 13
	speed = 10
	move_to_delay = 4
	search_objects = 1
	wanted_objects = list(/obj/structure/closet)
	vision_range = 5
	aggro_vision_range = 12

/mob/living/simple_animal/hostile/horrormob/hermit/AttackingTarget()
	if(target == /obj/structure/closet)
		var/obj/structure/closet/Cl = target
		Cl.dive_into(user = src)
		return
	else
		return ..()

/mob/living/simple_animal/hostile/horrormob/hermit/EscapeConfinement()
	return //so it doesn't just destroy lockers from the inside



