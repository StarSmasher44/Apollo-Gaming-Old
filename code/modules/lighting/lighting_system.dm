/var/list/lighting_update_lights = list()
/var/list/lighting_update_overlays = list()

/area/var/lighting_use_dynamic = 1

// duplicates lots of code, but this proc needs to be as fast as possible.
/proc/create_all_lighting_overlays()
	for (var/zlevel = 1 to world.maxz)
		for (var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			var/area/A = T.loc
			if (!A.lighting_use_dynamic)
				continue
				var/atom/movable/lighting_overlay/O = new /atom/movable/lighting_overlay(T)
				T.lighting_overlay = O


/proc/create_lighting_overlays(zlevel = 0)
	if(zlevel == 0) // populate all zlevels
		for(var/turf/T in world)
			if(T.dynamic_lighting)
				var/area/A = T.loc
				if(A.lighting_use_dynamic)
					var/atom/movable/lighting_overlay/O = new /atom/movable/lighting_overlay(T)
					T.lighting_overlay = O
	else
		for(var/x = 1; x <= world.maxx; x++)
			for(var/y = 1; y <= world.maxy; y++)
				var/turf/T = locate(x, y, zlevel)
				if(T.dynamic_lighting)
					var/area/A = T.loc
					if(A.lighting_use_dynamic)
						var/atom/movable/lighting_overlay/O = new /atom/movable/lighting_overlay(T)
						T.lighting_overlay = O
