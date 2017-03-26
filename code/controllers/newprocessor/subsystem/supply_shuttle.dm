var/datum/subsystem/supply_shuttle/SShuttle


/datum/subsystem/shuttle
	name       = "Shuttle"
	init_order = SS_INIT_SUPPLY_SHUTTLE
	flags      = SS_NO_TICK_CHECK
	wait       = 2 SECONDS


/datum/subsystem/supply_shuttle/New()
	NEW_SS_GLOBAL(SShuttle)


/datum/subsystem/supply_shuttle/Initialize(timeofday)
	if(!shuttle_controller)
		shuttle_controller = new

/datum/subsystem/supply_shuttle/fire(resumed = FALSE)
	shuttle_controller.process()