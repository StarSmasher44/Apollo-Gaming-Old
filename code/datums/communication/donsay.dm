/decl/communication_channel/ooc
	name = "Donsay"
	config_setting = "ooc_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_NO_GUESTS
	log_proc = /proc/log_ooc
	mute_setting = MUTE_OOC
	show_preference_setting = /datum/client_preference/show_ooc

/decl/communication_channel/donsay/can_communicate(var/client/C, var/message)
	. = ..()
	if(!.)
		return

	if(!C.holder)
		if(!config.dooc_allowed && (C.mob.stat == DEAD))
			to_chat(C, "<span class='danger'>[name] for dead mobs has been turned off.</span>")
			return FALSE
		if(findtext(message, "byond://"))
			to_chat(C, "<B>Advertising other servers is not allowed.</B>")
			log_and_message_admins("has attempted to advertise in [name]: [message]")
			return FALSE

/decl/communication_channel/donsay/do_communicate(var/client/C, var/message)
	for(var/client/target in clients)
		if(target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue
		var/sent_message = "[create_text_tag("DON", "DON:", target)] <EM>[C.key]:</EM> <span class='message'>[message]</span>"
		receive_communication(C, target, "<font color='#8D2B96'><span class='donator'>[sent_message]</font></span>")


/decl/communication_channel/donsay/proc/can_receive(var/client/C, var/mob/M)
	if(istype(C) && C.mob == M)
		return TRUE
	if(istype(C) && M.is_key_ignored(C.key))
		return FALSE
	if(istype(C) && C.donator)
		return TRUE
	return TRUE
