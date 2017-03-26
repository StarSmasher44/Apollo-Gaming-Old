#define TICK_LIMIT_RUNNING 82
#define TICK_LIMIT_TO_RUN 78
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT 98

#define TICK_CHECK ( world.tick_usage > TICK_LIMIT_RUNNING ? stoplag() : 0 )
#define CHECK_TICK if (world.tick_usage > TICK_LIMIT_RUNNING)  stoplag()
//#define CHECK_TICK2(ticklimit) if(world.tick_usage > ticklimit) stoplag()
//#define MC_TICK_CHECK ( world.tick_usage > TICK_LIMIT_RUNNING ? pause() : 0 )
#define CHECK_TICK2(ticklimit)          \
	if(world.tick_usage > ticklimit)    \
	{                                   \
		stoplag()                       \
	}

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100) * max(processScheduler.sleep_delta,1)), 1)

/proc/stoplag()
	. = 0
	var/i = 1
	do
		. += round(i*DELTA_CALC)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (world.tick_usage > min(TICK_LIMIT_TO_RUN, TICK_LIMIT_RUNNING))

#undef DELTA_CALC