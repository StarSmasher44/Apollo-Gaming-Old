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
			else
				usr << "<span class='danger'>Could not add [C] to the whitelist. Perhaps they're already whitelisted?</span>"
		if("Alien Whitelist")
			var/race = input("Which species?") as null|anything in whitelisted_species
			if(!race)
				return
			if(setWhitelist(C, 2, "[race]"))
				message_admins("[key_name_admin(usr)] has whitelisted [C] for [race].")
			else
				usr << "<span class='danger'>Could not add [race] to the whitelist of [C]. Perhaps they've already got that one?</span>"
		if("Donators")
			if(setWhitelist(C, 3))
				message_admins("[key_name_admin(usr)] has added [C] as a donator.")
			else
				usr << "<span class='danger'>Could not add [C] to donators. Perhaps they're already set?</span>"