
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
		Cl.dive_into(src)
		return
	else
		return ..()

/mob/living/simple_animal/hostile/horrormob/hermit/EscapeConfinement()
	return //so it doesn't just destroy lockers from the inside






/*

// canceled or unfinished horrormobs

/mob/living/simple_animal/hostile/horrormob/photo
	name = ""
	desc = ""
	health = 20
	maxHealth = 20
	icon_state = ""
	icon_living = ""
	icon_dead = "" // totaly invisible
	del_on_death = TRUE
	retreat_distance = 4
	minimum_distance = 6
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS | PASSMOB | PASSMACHINE | PASSSTRUCTURE | PASSDOORS // only can't pass walls

/mob/living/simple_animal/hostile/horrormob/photo/Aggro()
	captureimage(target, src, 4, 4)
	do_teleport(src,find_safe_turf(zlevels = src.z, extended_safety_checks = FALSE),channel = TELEPORT_CHANNEL_MAGIC)
	return ..()


// mostly copypasted and shortened code from photography/camera.dm without unnecessary checks for the mob. this probably needs to be optimised
/mob/living/simple_animal/hostile/horrormob/photo/proc/captureimage(atom/target, mob/user, flag, size_x = 4, size_y = 4)
	blending = TRUE
	var/turf/target_turf = get_turf(target)
	if(!isturf(target_turf))
		blending = FALSE
		return FALSE
	var/list/desc = list("This is a photo of an area of [size_x+1] meters by [size_y+1] meters.")
	var/list/mobs_spotted = list()
	var/list/dead_spotted = list()
	var/list/seen
	var/list/viewlist = (user && user.client)? getviewsize(user.client.view) : getviewsize(world.view)
	var/viewr = max(viewlist[1], viewlist[2]) + max(size_x, size_y)
	var/viewc = user.client? user.client.eye : target
	seen = get_hear(viewr, get_turf(viewc))
	var/list/turfs = list()
	var/list/mobs = list()
	var/blueprints = FALSE
	var/clone_area = SSmapping.RequestBlockReservation(size_x * 2 + 1, size_y * 2 + 1)
	for(var/turf/placeholder in block(locate(target_turf.x - size_x, target_turf.y - size_y, target_turf.z), locate(target_turf.x + size_x, target_turf.y + size_y, target_turf.z)))
		var/turf/T = placeholder
		while(istype(T, /turf/open/openspace)) //Multi-z photography
			T = SSmapping.get_turf_below(T)
			if(!T)
				break
	for(var/i in mobs)
		var/mob/M = i
		mobs_spotted += M
		if(M.stat == DEAD)
			dead_spotted += M
		desc += M.get_photo_description(src)
	var/psize_x = (size_x * 2 + 1) * world.icon_size
	var/psize_y = (size_y * 2 + 1) * world.icon_size
	var/get_icon = camera_get_icon(turfs, target_turf, psize_x, psize_y, clone_area, size_x, size_y, (size_x * 2 + 1), (size_y * 2 + 1))
	qdel(clone_area)
	var/icon/temp = icon('icons/effects/96x96.dmi',"")
	temp.Blend("#000", ICON_OVERLAY)
	temp.Scale(psize_x, psize_y)
	temp.Blend(get_icon, ICON_OVERLAY)
	var/datum/picture/P = new("picture", desc.Join(" "), mobs_spotted, dead_spotted, temp, null, psize_x, psize_y, blueprints)
	printpicture(user, P)
	blending = FALSE


/mob/living/simple_animal/hostile/horrormob/photo/proc/printpicture(mob/user, datum/picture/picture) //Normal camera proc for creating photos
	var/obj/item/photo/p = new(get_turf(src), picture)
	if(in_range(src, user)) //needed because of TK
		user.put_in_hands(p)
		pictures_left--
		to_chat(user, "<span class='notice'>[pictures_left] photos left.</span>")
		var/customise = "No"
		if(can_customise)
			customise = alert(user, "Do you want to customize the photo?", "Customization", "Yes", "No")
		if(customise == "Yes")
			var/name1 = stripped_input(user, "Set a name for this photo, or leave blank. 32 characters max.", "Name", max_length = 32)
			var/desc1 = stripped_input(user, "Set a description to add to photo, or leave blank. 128 characters max.", "Caption", max_length = 128)
			var/caption = stripped_input(user, "Set a caption for this photo, or leave blank. 256 characters max.", "Caption", max_length = 256)
			if(name1)
				picture.picture_name = name1
			if(desc1)
				picture.picture_desc = "[desc1] - [picture.picture_desc]"
			if(caption)
				picture.caption = caption
		else
			if(default_picture_name)
				picture.picture_name = default_picture_name

		p.set_picture(picture, TRUE, TRUE)
		if(CONFIG_GET(flag/picture_logging_camera))
			picture.log_to_file()

*/


