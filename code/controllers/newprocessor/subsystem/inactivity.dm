var/datum/subsystem/inactivity/SSinactivity


/datum/subsystem/inactivity
	name = "Inactivity"
	wait = 120 SECONDS
	flags = SS_NO_INIT | SS_BACKGROUND | SS_FIRE_IN_LOBBY
	priority = SS_PRIORITY_INACTIVITY


/datum/subsystem/inactivity/New()
	NEW_SS_GLOBAL(SSinactivity)


/datum/subsystem/inactivity/fire(resumed = FALSE)
	if(config.kick_inactive)
		for(var/last_object in clients)
			var/client/C = last_object
			if(!C.holder && C.is_afk(config.kick_inactive MINUTES))
				if(!isobserver(C.mob))
					log_access("AFK: [key_name(C)]")
					to_chat(C, "<SPAN CLASS='warning'>You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.</SPAN>")
					qdel(C)
