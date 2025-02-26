/obj/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'

/obj/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)


/obj/screen/ghost/moveup
	name = "Ascend"
	icon_state = "up"

/obj/screen/ghost/moveup/Click()
	usr.zMove(UP, TRUE)

/obj/screen/ghost/movedown
	name = "Descend"
	icon_state = "down"

/obj/screen/ghost/movedown/Click()
	usr.zMove(DOWN, TRUE)

/obj/screen/ghost/jumptomob
	name = "Jump to mob"
	icon_state = "jumptomob"

/obj/screen/ghost/jumptomob/Click()
	var/mob/dead/observer/G = usr
	G.jumptomob()

/obj/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"

/obj/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/obj/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"

/obj/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/obj/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"

/obj/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/obj/screen/ghost/pai
	name = "pAI Candidate"
	icon_state = "pai"

/obj/screen/ghost/pai/Click()
	var/mob/dead/observer/G = usr
	G.register_pai()

/datum/hud/ghost/New(mob/owner)
	..()
	var/obj/screen/using

	using = new /obj/screen/ghost/jumptomob()
	using.screen_loc = ui_ghost_jumptomob
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/orbit()
	using.screen_loc = ui_ghost_orbit
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/teleport()
	using.screen_loc = ui_ghost_teleport
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/pai()
	using.screen_loc = ui_ghost_pai
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/moveup
	using.screen_loc = ui_ghost_up
	using.hud = src
	static_inventory += using

	using = new /obj/screen/ghost/movedown
	using.screen_loc = ui_ghost_down
	using.hud = src
	static_inventory += using

	using = new /obj/screen/language_menu
	using.icon = ui_style
	using.hud = src
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory
