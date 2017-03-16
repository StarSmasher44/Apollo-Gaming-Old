var/list/donators = list()

/client
	var/donator = 0 // Is donator is not donator?

/proc/load_donators_sql()
	var/DBQuery/query = dbcon_old.NewQuery("SELECT * FROM whitelist WHERE donator = 1")
	if(!query.Execute())
		world.log << dbcon_old.ErrorMsg()
		return 0
	else
		while(query.NextRow())
			var/list/row = query.GetRowData()
			donators.Add(row["ckey"])
	return 1

/proc/is_donator(mob/M)
	if(!donators)
		return 0
	if(check_rights(R_MOD, 0, M))
		return 1
	return ("[M.ckey]" in donators)

/client/verb/CheckDonator()
	set name = "Check Donator"
	set desc = "Checks your donation status"
	set category = "OOC"

	if(donator)		//swippity swoppity
		src << "You are registed as a donator, Thanks a lot!"
	else
		src << "You are not a registered donator. If you have donated please contact a member of staff to enquire."

/client/verb/cmd_don_say(msg as text)
	set category = "OOC"
	set name = "Donsay"
	set hidden = 1

	if(!msg)
		return

	if(!donator)
		if(!check_rights(R_ADMIN|R_MOD))
			usr << "Only donators and staff can use this command."
			return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	log_admin("DON: [key_name(src)] : [msg]")
	for(var/client/C in clients)
		if((C.holder && (C.holder.rights & R_ADMIN || C.holder.rights & R_MOD)) || C.donator)
			C << "<span class='donatorsay'>" + create_text_tag("don", "DON:", C) + " <b>[src]: </b><span class='message'>[msg]</span></span>"

/proc/setWhitelist(var/client/C, var/option, var/species = "") // OPTION; 1 for heads, 2 for aliens, 3 for donators.
	if(!C || !C.ckey || !option || option == 2 && !species)
		return 0
	switch(option)
		if(1) // Heads
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon_old.ErrorMsg()
				return 0
			var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET jobwhitelist = '[1]' WHERE ckey = '[C.ckey]'")
			if(query_insert.Execute())
				return 1
		if(2) // Aliens
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon_old.ErrorMsg()
				return 0
			var/aliens = ""
			while(query.NextRow())
				var/list/row = query.GetRowData()
				aliens = "[row["race"]],[species]" //Take the previous and Add them to the list
			var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET race = '[aliens]' WHERE ckey = '[C.ckey]'")
			if(query_insert.Execute())
				return 1
		if(3) // Donators
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist WHERE ckey = '[C.ckey]'")
			query.Execute()
			if(!query.Execute())
				world.log << dbcon_old.ErrorMsg()
				return 0
			var/DBQuery/query_insert = dbcon.NewQuery("UPDATE whitelist SET donator = '[1]' WHERE ckey = '[C.ckey]'")
			if(query_insert.Execute())
				return 1
