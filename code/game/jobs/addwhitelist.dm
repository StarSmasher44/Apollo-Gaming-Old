/client/proc/add_whitelist()
	set category = "Admin"
	set name = "Write to Whitelist"
	set desc = "Adds a user to any whitelist available in the directory mid-round."

	if(!check_rights(R_ADMIN|R_MOD))
		return

	var/client/C = input("Please, select a player!", "Add User to Whitelist") as anything in clients
	if(!C || C == src)
		return

	var/type = input("Select what type of whitelist", "Add User to Whitelist") as null|anything in list( "Whitelist", "Alien Whitelist", "Donators" )

	switch(type)
		if("Whitelist")
			if(setWhitelist(C, 1))
				message_admins("[key_name_admin(usr)] has whitelisted [C].")
				to_chat(C, "Whitelisted for command roles.")
			else
				usr << "<span class='danger'>Could not add [C] to the whitelist. Perhaps they're already whitelisted?</span>"
		if("Alien Whitelist")
			var/race = input("Which species?") as null|anything in whitelisted_species
			if(!race)
				return
			if(setWhitelist(C, 2, "[race]"))
				message_admins("[key_name_admin(usr)] has whitelisted [C] for [race].")
				to_chat(C, "Whitelisted for race [race].")
			else
				usr << "<span class='danger'>Could not add [race] to the whitelist of [C]. Perhaps they've already got that one?</span>"
		if("Donators")
			if(setWhitelist(C, 3))
				message_admins("[key_name_admin(usr)] has added [C] as a donator.")
				to_chat(C, "Donator status added.")
			else
				usr << "<span class='danger'>Could not add [C] to donators. Perhaps they're already set?</span>"

/proc/setWhitelist(var/client/C, var/option, var/species = "") // OPTION; 1 for heads, 2 for aliens, 3 for donators.
	if(!C || !C.ckey || !option || (option == 2 && !species))
		return 0
	switch(option)
		if(1) // Heads
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon.ErrorMsg()
				return 0
			var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET jobwhitelist = '[1]' WHERE ckey = '[C.ckey]'")
			if(query_insert.Execute())
				return 1
		if(2) // Aliens
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon.ErrorMsg()
				return 0
			var/aliens = ""
			while(query.NextRow())
				var/list/row = query.GetRowData()
				if(!findtext(row["race"], aliens)) // We did not find the selected alium already enabled.
					aliens = "[row["race"]],[species]" //Take the previous and Add them to the list
					var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET race = '[aliens]' WHERE ckey = '[C.ckey]'")
					if(query_insert.Execute())
						return 1
				else
					to_chat(usr, "<span class='warning'>ERROR: Whitelist was already found. Whitelisted aliens: [row["race"]]</span>")
					return 0
		if(3) // Donators
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon.ErrorMsg()
				return 0
			var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET donator = '[1]' WHERE ckey = '[C.ckey]'")
			if(query_insert.Execute())
				return 1