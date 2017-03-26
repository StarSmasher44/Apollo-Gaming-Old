var/datum/subsystem/wireless/SSwireless

var/list/wirelesss = list()


/datum/subsystem/wireless
	name     = "wireless"
	wait     = 5 SECONDS
	flags    = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_DISEASE

	var/list/receiver_list
	var/list/pending_connections
	var/list/retry_connections
	var/list/failed_connections


/datum/subsystem/wireless/New()
	NEW_SS_GLOBAL(SSwireless)
	pending_connections = new()
	retry_connections = new()
	failed_connections = new()
	receiver_list = new()

/datum/subsystem/wireless/stat_entry()
	..("E:[wirelesss.len]")


/datum/subsystem/wireless/fire(resumed = FALSE)
	//process any connection requests waiting to be retried
	if(retry_connections.len > 0)
		//any that fail are moved into the failed connections list
		process_queue(retry_connections, failed_connections)

	//process any pending connection requests
	if(pending_connections.len > 0)
		//any that fail are moved to the retry queue
		process_queue(pending_connections, retry_connections)

/datum/subsystem/wireless/proc/process_queue(var/list/process_conections, var/list/unsuccesful_connections)
	for(last_object in process_conections)
		var/datum/connection_request/C = last_object
		var/target_found = 0
		for(var/datum/wifi/receiver/R in receiver_list)
			if(R.id == C.id)
				var/datum/wifi/sender/S = C.source
				S.connect_device(R)
				R.connect_device(S)
				target_found = 1
		process_conections -= C
		if(!target_found)
			unsuccesful_connections += C

/datum/subsystem/wireless/proc/add_device(var/datum/wifi/receiver/R)
	if(receiver_list)
		receiver_list |= R
	else
		receiver_list = new()
		receiver_list |= R

/datum/subsystem/wireless/proc/remove_device(var/datum/wifi/receiver/R)
	if(receiver_list)
		receiver_list -= R

/datum/subsystem/wireless/proc/add_request(var/datum/connection_request/C)
	if(pending_connections)
		pending_connections += C
	else
		pending_connections = new()
		pending_connections += C
