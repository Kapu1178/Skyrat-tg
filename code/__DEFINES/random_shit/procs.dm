//funny adminbus
/mob/living/carbon/human/proc/steal_oc(var/mob/living/carbon/human/victim)
	dna.features = list()
	dna.body_markings = list()
	dna.mutant_bodyparts = list()
	victim.client?.prefs.apply_prefs_to(src, TRUE)
	src.hair_color = victim.hair_color
	src.hairstyle = victim.hairstyle
	src.facial_hair_color = victim.facial_hair_color
	src.facial_hairstyle = victim.facial_hairstyle
	src.eye_color = victim.eye_color
	update_hair()
	updateappearance(icon_update=TRUE, mutcolor_update=TRUE, mutations_overlay_update=TRUE)

/mob/living/carbon/human/proc/set_size(size)
	dna.features["body_size"] = size
	dna.update_body_size()

/proc/toggle_lights(state = TRUE)
	for(var/obj/machinery/light_switch/l_switch in GLOB.machines)
		l_switch.set_lights(state)

/obj/effect/proc_holder/spell/targeted/sloppy_kiss
	name = "Sloppy Kiss"
	desc = "You can guess what this does"
	var/datum/reagents/saliva_holder
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_background_icon_state = "bg_spell"
	action_icon_state = "spikechemswap"
	charge_max = 0
	clothes_req = 0
	range = 1
	include_user = 0


/obj/effect/proc_holder/spell/targeted/sloppy_kiss/on_lose(mob/living/user)
	. = ..()
	saliva_holder = null

/obj/effect/proc_holder/spell/targeted/sloppy_kiss/cast(list/targets, mob/living/carbon/human/user = usr)
	var/amount_to_transfer = input(user, "How much of your saliva do you wish to transfer?","Enter transfer amount", 10) as num|null
	amount_to_transfer = clamp(amount_to_transfer, 0, saliva_holder.total_volume)
	if(!amount_to_transfer)
		return

	for(var/mob/living/M in targets)
		user.visible_message(span_hypnophrase("[user.name] thrusts their tongue into [M.name]'s mouth, engaging in a sloppy kiss!"), span_hypnophrase("You sloppily kiss [M.name], leaving some saliva in their mouth."))
		saliva_holder.trans_to(target = M, amount = amount_to_transfer, methods = INGEST)

	if(saliva_holder.total_volume)
		to_chat(user, span_notice("Your saliva now contains:\n"))
		for(var/datum/reagent/reagent in saliva_holder.reagent_list)
			to_chat(user, span_notice("[reagent.volume]u of [reagent.name]\n"))
		to_chat(user, span_notice("([saliva_holder.total_volume]/[saliva_holder.maximum_volume])"))

/datum/action/innate/synthesize_chems
	name = "Synthesize Saliva"
	icon_icon = 'icons/obj/drinks.dmi'
	button_icon_state = "changelingsting"
	background_icon_state = "bg_changeling"
	var/datum/reagents/reagent_holder

/datum/action/innate/synthesize_chems/Grant()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/obj/item/organ/tongue/robot_ipc/tongue = H.getorganslot(ORGAN_SLOT_TONGUE)
		reagent_holder = tongue.reagents

/datum/action/innate/synthesize_chems/Remove()
	. = ..()
	reagent_holder = null

/datum/action/innate/synthesize_chems/Activate()
	var/valid_id
	var/chosen_id
	while(!valid_id)
		chosen_id = input(owner, "Enter the ID of the reagent you want to add.", "Search reagents") as null|text
		if(isnull(chosen_id))
			break
		if(!ispath(text2path(chosen_id)))
			chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
			if(ispath(chosen_id))
				valid_id = TRUE
			if(!valid_id)
				to_chat(owner, span_warning("A reagent with that ID doesn't exist!"))
	if(chosen_id)
		var/amount = input(owner, "Choose the amount to add.", "Choose the amount.", reagent_holder.maximum_volume) as num|null
		reagent_holder.add_reagent(chosen_id, amount)

	if(reagent_holder.total_volume)
		to_chat(owner, span_notice("Your saliva now contains:\n"))
		for(var/datum/reagent/reagent in reagent_holder.reagent_list)
			to_chat(owner, span_notice("[reagent.volume]u of [reagent.name]\n"))
		to_chat(owner, span_notice("([reagent_holder.total_volume]/[reagent_holder.maximum_volume])"))

////CURSED DOGBORG SHIT - YOU KNOW WHO YOU ARE, FUCK YOU.
/datum/action/innate/synthesize_chems/borg
	name = "Synthesize Saliva"
	icon_icon = 'icons/obj/drinks.dmi'
	button_icon_state = "changelingsting"
	background_icon_state = "bg_changeling"

/datum/action/innate/synthesize_chems/borg/Grant()
	. = ..()
	if(iscyborg(owner))
		var/mob/living/silicon/robot/borg = owner
		var/obj/item/dogborg_tongue/tongue = locate() in borg.model.basic_modules
		reagent_holder = tongue.reagents



///Honk
/obj/effect/proc_holder/spell/targeted/kapumoment
	name = "Clothing Synthesizer"
	desc = "You can guess what this does"
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_background_icon_state = "bg_spell"
	action_icon_state = "spikechemswap"
	charge_max = 0
	clothes_req = 0
	range = 1
	include_user = 0
	var/static/list/literally_every_item_in_the_game

	var/obj/item/muh_item

/obj/effect/proc_holder/spell/targeted/kapumoment/Initialize()
	. = ..()
	if(!literally_every_item_in_the_game)
		literally_every_item_in_the_game = subtypesof(/obj/item)

/obj/effect/proc_holder/spell/targeted/kapumoment/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!muh_item)
		var/object = input(user, "Item By Path", "Item By Path", null) as null|text
		var/list/preparsed = splittext(object,":")
		var/path = preparsed[1]

		var/chosen = pick_closest_path(path)
		if(!chosen)
			return

		if(!ispath(chosen, /obj/item))
			return

		muh_item = new chosen(src)

		muh_item.attack_self(user)

	else
		for(var/mob/living/carbon/human/M in targets)
			if(!M.equip_to_slot_if_possible(muh_item, muh_item.slot_flags))
				QDEL_NULL(muh_item)
			else
				muh_item = null
