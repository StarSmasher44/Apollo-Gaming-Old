// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera.triggerAlarm() rather than alarm_manager.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
/var/global/datum/alarm_handler/atmosphere/atmosphere_alarm	= new()
/var/global/datum/alarm_handler/camera/camera_alarm			= new()
/var/global/datum/alarm_handler/fire/fire_alarm				= new()
/var/global/datum/alarm_handler/motion/motion_alarm			= new()
/var/global/datum/alarm_handler/power/power_alarm			= new()

// Alarm Manager, the manager for alarms.
var/datum/subsystem/obj/SSalarm_manager

/datum/subsystem/alarm_manager
	name          = "alarm manager"
	init_order    = SS_INIT_OBJECT
	display_order = SS_DISPLAY_OBJECTS
	priority      = SS_PRIORITY_DISEASE
	wait          = 2 SECONDS

	var/list/currentrun
	var/list/datum/alarm/all_handlers


/datum/subsystem/alarm_manager/New()
	NEW_SS_GLOBAL(SSalarm_manager)


/datum/subsystem/alarm_manager/Initialize()
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	alarm_manager = src
	..()

/datum/subsystem/alarm_manager/stat_entry()
	..("P:[processing_objects.len]")


/datum/subsystem/alarm_manager/fire(resumed = FALSE)
	if (!resumed)
		currentrun = global.processing_objects.Copy()

	for(var/last_object in all_handlers)
		var/datum/alarm_handler/AH = last_object
		AH.process()
		if (MC_TICK_CHECK)
			return

/datum/subsystem/alarm_manager/proc/active_alarms()
	var/list/all_alarms = new
	for(var/datum/alarm_handler/AH in all_handlers)
		var/list/alarms = AH.alarms
		all_alarms += alarms

	return all_alarms

/datum/subsystem/alarm_manager/proc/number_of_active_alarms()
	var/list/alarms = active_alarms()
	return alarms.len

/datum/subsystem/alarm_manager/stat_entry()
	..()
	stat(null, "[number_of_active_alarms()] alarm\s")