/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "Podperson"
	id = "pod"
	default_color = "59CE00"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR,FACEHAIR,WINGCOLOR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "mam_snouts", "legs", "deco_wings")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_snouts" = "None", "mam_tail" = "None", "mam_ears" = "None", "mam_body_markings" = "None", "legs" = "Normal Legs" , "deco_wings" = "None" )
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.25
	heatmod = 1.5
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/plant
	disliked_food = MEAT | DAIRY
	liked_food = VEGETABLES | FRUIT | GRAIN
	var/light_nutrition_gain_factor = 10
	var/light_toxheal = 1
	var/light_oxyheal = 1
	var/light_burnheal = 1
	var/light_bruteheal = 1

/datum/species/pod/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.faction |= "plants"
	C.faction |= "vines"

/datum/species/pod/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.faction -= "plants"
	C.faction -= "vines"

/datum/species/pod/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = min(1,T.get_lumcount()) - 0.5
		H.nutrition = min(H.nutrition + light_amount * light_nutrition_gain_factor, NUTRITION_LEVEL_FULL)
		if(light_amount > 0.2) //if there's enough light, heal
			H.heal_overall_damage(light_bruteheal, light_burnheal)
			H.adjustToxLoss(-light_toxheal)
			H.adjustOxyLoss(-light_oxyheal)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

/datum/species/pod/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == /datum/reagent/toxin/plantbgone)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)
		return 1

/datum/species/pod/on_hit(obj/item/projectile/P, mob/living/carbon/human/H)
	switch(P.type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.rad_act(rand(30,80))
				H.Knockdown(100)
				H.visible_message("<span class='warning'>[H] writhes in pain as [H.p_their()] vacuoles boil.</span>", "<span class='userdanger'>You writhe in pain as your vacuoles boil!</span>", "<span class='italics'>You hear the crunching of leaves.</span>")
				if(prob(80))
					H.easy_randmut(NEGATIVE+MINOR_NEGATIVE)
				else
					H.easy_randmut(POSITIVE)
				H.domutcheck()
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='userdanger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)

/datum/species/pod/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/pod/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/pod/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/pod/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/pod/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/pod/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()


/datum/species/pod/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/pod/pseudo_weak
	id = "podweak"
	limbs_id = "pod"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "mam_snouts", "taur", "legs")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_snouts" = "Husky", "mam_tail" = "Husky", "mam_ears" = "Husky", "mam_body_markings" = "Husky", "taur" = "None", "legs" = "Normal Legs")
	light_nutrition_gain_factor = 7.5
	light_bruteheal = 0.2
	light_burnheal = 0.2
	light_toxheal = 0.7

/datum/species/pod/tree
	id = "treeperson" //Living tree, much more durable, heals faster.
	limbs_id = "pod"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS,WINGCOLOR)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTLOWPRESSURE,TRAIT_RESISTHIGHPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOBREATH)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "mam_snouts", "taur", "legs")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_snouts" = "Husky", "mam_tail" = "Husky", "mam_ears" = "Husky", "mam_body_markings" = "Husky", "taur" = "None", "legs" = "Normal Legs")
	light_nutrition_gain_factor = 10
	light_bruteheal = 5 //Heals fast
	light_burnheal = 5
	light_toxheal = 5
	light_oxyheal = 5
	armor = 50 //Hard skin
	brutemod = 0.4 //Hard to damage with conventional methods
	burnmod = 1.1 //burns easier, but still less than normal podpeople
