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
	dna.update_body_size(size)

/proc/toggle_lights(state = TRUE)
	for(var/obj/machinery/light_switch/l_switch in GLOB.machines)
		l_switch.set_lights(state)
