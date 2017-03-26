var/datum/subsystem/event/SSevent

var/list/events = list()


/datum/subsystem/event
	name     = "Event"
	wait     = 2 SECONDS
	flags    = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_EVENT

	var/list/currentrun


/datum/subsystem/event/New()
	NEW_SS_GLOBAL(SSevent)


/datum/subsystem/event/stat_entry()
	..("E:[events.len]")


/datum/subsystem/event/fire(resumed = FALSE)
	for(var/last_object in event_manager.active_events)
		var/datum/event/E = last_object
		E.process()
		CHECK_TICK

	for(var/i = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		var/last_object = event_manager.event_containers[i]
		var/list/datum/event_container/EC = last_object
		EC.process()

		if (MC_TICK_CHECK)
			return

	checkEvent()
