// What in the name of god is this?
// You'd think it'd be some form of process for the HTML interface module.
// But it isn't?
// It's some form of proc queue but ???
// Does anything even *use* this?

var/datum/subsystem/html_ui/SShtml_ui




/datum/subsystem/html_ui
	name = "HTMLUI"
	wait = 1.7 SECONDS
	flags = SS_NO_INIT | SS_NO_TICK_CHECK | SS_FIRE_IN_LOBBY

	var/list/tg_open_uis = list() // A list of open UIs, grouped by src_object and ui_key.
	var/list/processing_uis = list() // A list of processing UIs, ungrouped.
	var/basehtml // The HTML base used for all UIs.


/datum/subsystem/html_ui/New()
	NEW_SS_GLOBAL(SShtml_ui)
	basehtml = file2text('tgui/tgui.html') // Read the HTML from disk.

/datum/subsystem/html_ui/fire(resumed = FALSE)
	for(var/gui in processing_uis)
		var/datum/tgui/ui = gui
		if(ui && ui.user && ui.src_object)
			ui.process()
			continue
		processing_uis.Remove(ui)
