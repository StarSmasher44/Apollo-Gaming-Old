var/datum/subsystem/trade/SStrade


/datum/subsystem/trade
	name       = "Trade"
	init_order = SS_INIT_SUPPLY_SHUTTLE
	wait       = 60 SECONDS

/datum/subsystem/trade/New()
	NEW_SS_GLOBAL(SStrade)

/datum/subsystem/trade/Initialize(timeofday)
	for(var/i in 1 to rand(1,3))
		generateTrader(1)

/datum/subsystem/trade/fire(resumed = FALSE)
	for(var/a in traders)
		var/datum/trader/T = a
		if(!T.tick())
			traders -= T
			qdel(T)
	if(prob(100-traders.len*10))
		generateTrader()

/datum/subsystem/trade/proc/generateTrader(var/stations = 0)
	var/list/possible = list()
	if(stations)
		possible += subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	else
		if(prob(5))
			possible += subtypesof(/datum/trader/ship/unique)
		else
			possible += subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)

	for(var/i in 1 to 10)
		var/type = pick(possible)
		var/bad = 0
		for(var/trader in traders)
			if(istype(trader,type))
				bad = 1
				break
		if(bad)
			continue
		traders += new type
		return