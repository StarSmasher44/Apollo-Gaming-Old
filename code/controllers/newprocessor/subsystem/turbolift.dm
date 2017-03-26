var/datum/subsystem/turbolift/SSturbolift

/datum/subsystem/turbolift
	name     = "Turbolift"
	wait     = 10 SECONDS
	flags    = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_DISEASE

	var/list/moving_lifts = list()

/datum/subsystem/turbolift/New()
	NEW_SS_GLOBAL(SSturbolift)


/datum/subsystem/turbolift/stat_entry()
	..("E:[events.len]")


/datum/subsystem/turbolift/fire(resumed = FALSE)
	for(var/liftref in moving_lifts)
		if(world.time < moving_lifts[liftref])
			continue
		var/datum/turbolift/lift = locate(liftref)
		if(lift.busy)
			continue
		spawn(0)
			lift.busy = 1
			if(!lift.do_move())
				moving_lifts[liftref] = null
				moving_lifts -= liftref
				if(lift.target_floor)
					lift.target_floor.ext_panel.reset()
					lift.target_floor = null
			else
				lift_is_moving(lift)
			lift.busy = 0

		if (MC_TICK_CHECK)
			return



/datum/subsystem/turbolift/proc/lift_is_moving(var/datum/turbolift/lift)
	moving_lifts["\ref[lift]"] = world.time + lift.move_delay