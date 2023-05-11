/*

Not really a megafauna, but shares some code with it so i'll place it there

*/

/mob/living/simple_animal/hostile/megafauna/blink
	name = "Blink"
	desc = ""
	health = 180
	maxHealth = 250
	attacktext = "judges"
	attack_sound = 'sound/magic/clockwork/ratvar_attack.ogg'
	icon_state = "blink"
	icon_living = "blink"
	icon_dead = ""
	friendly = "stares down"
	icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	speak_emote = list("roars")
	armour_penetration = 10
	melee_damage = 40
	speed = 10
	move_to_delay = 10
//	ranged = TRUE
	pixel_x = -32
	del_on_death = TRUE
	gps_name = "Com0"// would be funy
	deathmessage = "disintegrates."
	deathsound = 'sound/magic/demon_dies.ogg'
	attack_action_types = list(/datum/action/innate/megafauna_attack/spiral_attack)
//	small_sprite_type = /datum/action/small_sprite/megafauna/colossus

/datum/action/innate/megafauna_attack/blink_disapear
	name = "Hallucination Charge"
	icon_icon = 'icons/effects/static.dmi'
	button_icon_state = "1 heavy"
	chosen_message = "<span class='colossus'>You are now teleporting away from your target.</span>"
	chosen_attack_num = 1


/mob/living/simple_animal/hostile/megafauna/blink/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		disappear()
		return 0
	return ..()


/mob/living/simple_animal/hostile/megafauna/blink/proc/disappear()
	src.icon_state = "blink_disappearing"
	src.icon_living = "blink_disappearing"
	sleep(6)
	var/turf/safe_turf = find_safe_turf(zlevels = src.z, extended_safety_checks = TRUE)
	do_teleport(src.z,safe_turf,forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
	sleep(4)
	src.icon_state = "blink"
	src.icon_living = "blink"


///mob/living/simple_animal/hostile/megafauna/blink/ObjBump(obj/O)
//	return // maybe make it melt walls on contact or something


/mob/living/simple_animal/hostile/megafauna/blink/devour(mob/living/L)
	visible_message("<span class='colossus'>[src] disintegrates [L]!</span>")
	L.dust()

/mob/living/simple_animal/hostile/megafauna/blink/proc/can_be_seen(turf/destination)
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(getexpandedview(world.view, 1, 1), check))
			if(M != src && M.client && CanAttack(M) && !M.has_unlimited_silicon_privilege && !M.eye_blind)
				return M
		for(var/obj/mecha/M in view(getexpandedview(world.view, 1, 1), check)) //assuming if you can see them they can see you
			if(M.occupant?.client && !M.occupant.eye_blind)
				return M.occupant
	return null
