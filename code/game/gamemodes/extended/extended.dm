/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	report_type = "extended"
	false_report_weight = 0
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

	title_icon = "extended_white"

	var/secret = FALSE
/*
/datum/game_mode/extended/secret
	name = "secret extended"
	config_tag ="secret_extended"
	report_type = "traitor"	//So this won't appear with traitor report
	secret = TRUE
*/

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/generate_report()
	return "The transmission shows no syndicate or other EOTC activity in the sector, but the other threats can probably explain why. Only around 10% of sector's new threats were researched and it is already enough to permit everyone on the station to carry a weapon. Just try to hint that they should make makeshift weaponry by themselves so that we don't have to trust them with security gear."

/datum/game_mode/extended/generate_station_goals()
	if(secret)
		return ..()
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()
// [station_name()]
/datum/game_mode/extended/announced/send_intercept()
	var/greenshift_message = "Due to the station being located in an extraordinarily dangerous sector, this shift will not go as usual. All crew is advised to be somewhat prepared for self defence. We also advise to build mini-medbays in maintenance areas since some of the entities may try to take over the main one. All station construction projects have been authorized in case you need them"
	. += "<b><i>Central Command Status Summary</i></b><hr>"
	. += greenshift_message

	print_command_report(., "Central Command Status Summary", announce = FALSE)
	priority_announce(greenshift_message, "Security Report", SSstation.announcer.get_rand_report_sound())
