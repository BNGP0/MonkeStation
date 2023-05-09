/obj/effect/proc_holder/spell/targeted/touch/glass_rift
	name = "Glass rift"
	desc = "Touch spell that let's you interact with the mirror realm"
	hand_path = /obj/item/melee/touch_attack/glass_rift
	school = "evocation"
	charge_max = 30
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_mirror.dmi'
	action_icon_state = "glass_rift"
	action_background_icon_state = "bg_mirror"

/obj/item/melee/touch_attack/glass_rift
	name = "Glass Rift"
	desc = "A spell that allows you to enter the mirror realm "
	icon = 'icons/mob/actions/actions_mirror.dmi'
	icon_state = "glass_rift"
	item_state = "glass_rift"
	catchphrase = "ee "
	block_level = 1
	block_upgrade_walk = 2
	block_power = 5
	sharpness = IS_SHARP
//	block_sound = 'sound/weapons/egloves.ogg'
	block_flags = BLOCKING_ACTIVE | BLOCKING_NASTY
	item_flags = DROPDEL
	damtype = BURN
	force = 3


/obj/item/melee/touch_attack/glass_rift/attack_self(mob/user)
	to_chat(user, "<span class='danger'>You shift between dimensions for a moment... although you don't see any consequences of this</span>")
//	new /obj/effect/decal/cleanable/glass(A)
//	jaunt_in_time = 1
//	jaunt_duration = 3



	///Where we cannot create the rune?
//	var/static/list/blacklisted_turfs = typecacheof(list(/turf/closed,/turf/open/space,/turf/open/lava))


//	var/use_charge = FALSE
//	if(iscarbon(target))
//		use_charge = TRUE
//		var/mob/living/carbon/C = target
//		C.adjustFireLoss(5)
//		C.adjustStaminaLoss(10)
//		C.bleed_rate -= 1
//	var/list/knowledge = cultie.get_all_knowledge()

//	for(var/X in knowledge)
//		var/datum/eldritch_knowledge/EK = knowledge[X]
//		if(EK.on_mansus_grasp(target, user, proximity_flag, click_parameters))
//			use_charge = TRUE
//	if(use_charge)
//		return ..()

///Draws a rune on a selected turf


///Removes runes from the selected turf


