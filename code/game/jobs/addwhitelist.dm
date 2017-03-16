/client/proc/add_whitelist()
	set category = "Admin"
	set name = "Write to Whitelist"
	set desc = "Adds a user to any whitelist available in the directory mid-round."

	if(!check_rights(R_ADMIN|R_MOD))
		return

	var/client/input = input("Please, select a player!", "Add User to Whitelist") as null|anything in sortKey(clients)
	if(!input)
		return
	else
		input = input.ckey

	var/type = input("Select what type of whitelist", "Add User to Whitelist") as null|anything in list( "Whitelist", "Alien Whitelist", "Donators" )

	input = ckey(input)
	switch(type)
		if("Whitelist")
			if(setWhitelist(input, 1))
				message_admins("[key_name_admin(usr)] has whitelisted [input].")
			else
				usr << "<span class='danger'>Could not add [input] to the whitelist. Perhaps they're already whitelisted?</span>"
		if("Alien Whitelist")
			var/race = input("Which species?") as null|anything in whitelisted_species
			if(!race)
				return
			if(setWhitelist(input, 2, "[race]"))
				message_admins("[key_name_admin(usr)] has whitelisted [input] for [race].")
			else
				usr << "<span class='danger'>Could not add [race] to the whitelist of [input]. Perhaps they've already got that one?</span>"
		if("Donators")
			if(setWhitelist(input, 3))
				message_admins("[key_name_admin(usr)] has added [input] as a donator.")
			else
				usr << "<span class='danger'>Could not add [input] to donators. Perhaps they're already set?</span>"