var/global/list/turf/processing_turfs = list()
var/datum/subsystem/turf/SSturf


/datum/subsystem/turf
	name          = "Turf"
	init_order    = SS_INIT_SUN
	display_order = SS_DISPLAY_SUN
	priority      = SS_PRIORITY_SUN
	wait          = 2 SECONDS


/datum/subsystem/turf/New()
	NEW_SS_GLOBAL(SSturf)

/datum/subsystem/sun/fire(resumed = FALSE)
	for(var/last_object in processing_turfs)
		var/turf/T = last_object
		if(T.process() == PROCESS_KILL)
			processing_turfs.Remove(T)
		if (MC_TICK_CHECK)
			return

