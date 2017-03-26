var/datum/subsystem/emergency_shuttle/SSemergency_shuttle


/datum/subsystem/emergency_shuttle
	name       = "Emergency Shuttle"
	init_order = SS_INIT_EMERGENCY_SHUTTLE
	wait       = 2 SECONDS
	flags      = SS_KEEP_TIMING | SS_NO_TICK_CHECK



/datum/subsystem/emergency_shuttle/New()
	NEW_SS_GLOBAL(SSemergency_shuttle)


/datum/subsystem/emergency_shuttle/Initialize(timeofday)
	if(!evacuation_controller)
		evacuation_controller = new using_map.evac_controller_type ()
		evacuation_controller.set_up()

	..()


/datum/subsystem/emergency_shuttle/fire(resumed = FALSE)
	evacuation_controller.process()
