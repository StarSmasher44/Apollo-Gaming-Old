/obj/item/weapon/cartridge
	var/access_pda_ai = 0
	var/pda_ai_on = 0
	var/pda_ai_name = "pAI"
	var/pda_ai_owner

/obj/item/device/pda/hear_talk(mob/M as mob, text)
	if(M && (cartridge.pda_ai_owner == M || !cartridge.pda_ai_owner) && cartridge.access_pda_ai) //Mob heard is the owner, and owner has access to the PDA AI
//		world << "[M] is owner and Has access to PDA_AI"
		if(cartridge.pda_ai_on) //Only If the PDA AI is actually toggled on.
//			world << "PDA_AI is ON"
			if(findtext(text, cartridge.pda_ai_name)) // Oh shit, we heard our name!
				var/area/CurrentArea = get_area(src)
				if(findtext(text, "open door"))
					sleep(rand(5, 25))
					for(var/obj/machinery/door/airlock/A in oview(2)) // Only in view because it otherwise may not work.
						A.do_command("open")
				else if(findtext(text, "close door"))
					sleep(rand(5, 25))
					for(var/obj/machinery/door/airlock/A in oview(2)) // Only in view because it otherwise may not work.
						A.do_command("close")
				/*-------UNLOCK DOOR/AREA-------*/
				if(findtext(text, "unlock") && !text != "lock")
					if(findtext(text, "door"))
						sleep(rand(5, 25))
						for(var/obj/machinery/door/airlock/A in oview(2)) // Only in view because it otherwise may not work.
							A.do_command("unlock")
					else if(findtext(text, "area"))
						sleep(rand(5, 25))
						for(var/obj/machinery/door/airlock/A in CurrentArea)
							A.do_command("unlock")
				/*-------LOCK DOOR/AREA-------*/
				else if(findtext(text, "lock") && !findtext(text,"unlock"))
					if(findtext(text, "door"))
						sleep(rand(5, 25))
						for(var/obj/machinery/door/airlock/A in oview(2)) // Only in view because it otherwise may not work.
							A.do_command("lock")
					else if(findtext(text, "area"))
						sleep(rand(5, 25))
						for(var/obj/machinery/door/airlock/A in CurrentArea)
							A.do_command("lock")
				if(findtext(text, "power"))
					CurrentArea = get_area(src) // Re-do to ensure it's updated.
					if(findtext(text, "on"))
						if(findtext(text, "equipment"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.equipment = 2
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.equipment = 2
						if(findtext(text, "lights"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.lighting = 2
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.lighting = 2
						if(findtext(text, "environment"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.environ = 2
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.environ = 2
						if(findtext(text, "all"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.equipment = 2
								CurrentArea.apc.lighting = 2
								CurrentArea.apc.environ = 2
								CurrentArea.apc.operating = 1
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.equipment = 2
									CurrentArea.apc.lighting = 2
									CurrentArea.apc.environ = 2
									CurrentArea.apc.operating = 1
						else // Otherwise, just turn on all power here, since we're assuming that's what he meant.
							CurrentArea.apc.equipment = 2
							CurrentArea.apc.lighting = 2
							CurrentArea.apc.environ = 2
							CurrentArea.apc.operating = 1
					else if(findtext(text, "off"))
						if(findtext(text, "equipment"))
							if(findtext(text, "here"))
								CurrentArea.apc.equipment = 1
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.equipment = 1
						if(findtext(text, "lights"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.lighting = 1
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.lighting = 1
						if(findtext(text, "environment"))
							if(findtext(text, "here"))
								CurrentArea.apc.environ = 1
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.environ = 1
						if(findtext(text, "all"))
							if(findtext(text, "here"))
								sleep(rand(5, 25))
								CurrentArea.apc.equipment = 1
								CurrentArea.apc.lighting = 1
								CurrentArea.apc.environ = 1
								CurrentArea.apc.operating = 0
							else
								CurrentArea = Get_Area_Name("[text]")
								sleep(rand(5, 25))
								if(CurrentArea)
									CurrentArea.apc.equipment = 1
									CurrentArea.apc.lighting = 1
									CurrentArea.apc.environ = 1
									CurrentArea.apc.operating = 0
						else
							sleep(rand(5, 25))
							CurrentArea.apc.equipment = 1
							CurrentArea.apc.lighting = 1
							CurrentArea.apc.environ = 1
							CurrentArea.apc.operating = 0
					CurrentArea.apc.update_icon()
					CurrentArea.apc.update()
				if(findtext(text, "locate") || findtext(text, "location") || findtext(text, "where") || findtext(text, "where is"))
					for(var/mob/living/M2 in mob_list)
						if((M2.z == 1 || 2) && findtext(text, "[M2.name]") && M2.job != null) // Is on our layer, and we called out his name, AND he has a job aboard this station.
							var/area/MLoc
							for(var/obj/machinery/camera/C in view(7, M2)) // If there is a camera nearby to actually spot the fucker.
								MLoc = C.MyArea
								break // Found him, updated our variable, no need for more.
							sleep(rand(10, 35))
							if(MLoc)
								playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
								for (var/mob/O in hearers(2, src.loc))
									O.show_message(text("\icon[src] *[M2.name]* Located In [MLoc.name]"))
							else
								playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
								for (var/mob/O in hearers(2, src.loc))
									O.show_message(text("\icon[src] *[M2.name]* Unable to locate."))
/*				var/job
				else if(findtext(text, for(job in all_job_positions)))
					for(var/mob/living/M2 in mob_list)
						if((M2.z == 1 || 2) && M2.job == J) // Is on our layer, and we called out his name, AND he has a job aboard this station.
							var/mjob = M2.job
							var/area/MLoc
							for(var/obj/machinery/camera/C in view(7, M2)) // If there is a camera nearby to actually spot the fucker.
								MLoc = C.MyArea
								break // Found him, updated our variable, no need for more.
							sleep(rand(10, 35))
							if(MLoc)
								playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
								for (var/mob/O in hearers(2, src.loc))
									O.show_message(text("\icon[src] *[mjob] [M2.name]* Located In [MLoc.name]"))
							else
								playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
								for (var/mob/O in hearers(2, src.loc))
									O.show_message(text("\icon[src] *[mjob] [M2.name]* Unable to locate."))*/
				else if(findtext(text, "ownership") || findtext(text, "owner"))
					if(!cartridge.pda_ai_owner)
						M = cartridge.pda_ai_owner
		else
			if(findtext(text, cartridge.pda_ai_name)) // Oh shit, we heard our name!
				if(findtext(text, "on") || findtext(text, "enable") && !cartridge.pda_ai_on) // Get out of hibernative state.
					cartridge.pda_ai_on = 1
			//If command is sent to turn on, turn on.


/obj/item/device/pda/proc/Get_Area_Name(text as text)
	for(var/area/A in all_areas)
		if(findtext(text, "[A.name]"))
			if(A.z == 1 || 2) // No cheating goddamn it.
				return A