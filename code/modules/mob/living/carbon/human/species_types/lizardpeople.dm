/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Lizardperson"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,LIPS,WINGCOLOR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_REPTILE
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings", "legs", "taur", "deco_wings")
	mutanttongue = /obj/item/organ/tongue/lizard
	mutanttail = /obj/item/organ/tail/lizard
	coldmod = 1.5
	heatmod = 0.67
	default_features = list("mcolor" = "0F0", "mcolor2" = "0F0", "mcolor3" = "0F0", "tail_lizard" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "taur" = "None", "deco_wings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	gib_types = list(/obj/effect/gibspawner/lizard, /obj/effect/gibspawner/lizard/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	disliked_food = GRAIN | DAIRY
	liked_food = GROSS | MEAT
	inert_mutation = FIREBREATH

/datum/species/lizard/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/draconic)

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/lizard/qualifies_for_rank(rank, list/features)
	return TRUE

//I wag in death
/datum/species/lizard/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/lizard/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/lizard/can_wag_tail(mob/living/carbon/human/H)
	return ("tail_lizard" in mutant_bodyparts) || ("waggingtail_lizard" in mutant_bodyparts)

/datum/species/lizard/is_wagging_tail(mob/living/carbon/human/H)
	return ("waggingtail_lizard" in mutant_bodyparts)

/datum/species/lizard/start_wagging_tail(mob/living/carbon/human/H)
	if("tail_lizard" in mutant_bodyparts)
		mutant_bodyparts -= "tail_lizard"
		mutant_bodyparts -= "spines"
		mutant_bodyparts |= "waggingtail_lizard"
		mutant_bodyparts |= "waggingspines"
	H.update_body()

/datum/species/lizard/stop_wagging_tail(mob/living/carbon/human/H)
	if("waggingtail_lizard" in mutant_bodyparts)
		mutant_bodyparts -= "waggingtail_lizard"
		mutant_bodyparts -= "waggingspines"
		mutant_bodyparts |= "tail_lizard"
		mutant_bodyparts |= "spines"
	H.update_body()

/datum/species/lizard/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Digitigrade Legs")
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)
	return ..()

/datum/species/lizard/on_species_loss(mob/living/carbon/human/C, datum/species/new_species)
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Normal Legs")
		species_traits -= DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = "ashlizard"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_RESISTHEAT)
	mutantlungs = /obj/item/organ/lungs/ashwalker
	burnmod = 0.9
	brutemod = 0.9

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((C.dna.features["spines"] != "None" ) && (C.dna.features["tail_lizard"] == "None")) //tbh, it's kinda ugly for them not to have a tail yet have floating spines
		C.dna.features["tail_lizard"] = "Smooth"
		C.update_body()
	return ..()

/datum/species/lizard/ashwalker/alpha
	name = "Alpha Ash Walker" 
	id = "ashlizardalpha"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_RADRESONANCE,TRAIT_VIRUSIMMUNE,TRAIT_RADIMMUNE,TRAIT_RESISTHEAT,TRAIT_PIERCEIMMUNE,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_ALCOHOL_TOLERANCE,TRAIT_TOUGH,TRAIT_NODISMEMBER,TRAIT_STUNIMMUNE,TRAIT_EXEMPT_HEALTH_EVENTS)
	mutantlungs = /obj/item/organ/lungs/ashwalker/alpha
	mutant_heart = /obj/item/organ/heart/ashlizard/alpha
	burnmod = 0.7				//Immensely hard to kill
	brutemod = 0.7
	coldmod = 0.7
	punchdamagelow = 30
	punchdamagehigh = 50
	punchstunthreshold = 35 //Extremely high stun chance
	armor = 50						//Hard to kill

/datum/species/lizard/ashwalker/alpha/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.weather_immunities |= "lava"

/datum/species/lizard/ashwalker/alpha/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.weather_immunities -= "lava"

/datum/species/lizard/ashwalker/alpha/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return
	H.heal_overall_damage(2,2)
	H.adjustToxLoss(-2)
	H.adjustOxyLoss(-2)

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((C.dna.features["spines"] != "None" ) && (C.dna.features["tail_lizard"] == "None")) //tbh, it's kinda ugly for them not to have a tail yet have floating spines
		C.dna.features["tail_lizard"] = "Smooth"
		C.update_body()
	return ..()

//DEATHCLAW DEATHCLAW DEATHCLAW

/datum/species/lizard/deathclaw/glowing //More powerful deathclaw ahead!!!
	name = "Glowing Deathclaw"
	id = "glowdeathclaw"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RADRESONANCE,TRAIT_VIRUSIMMUNE,TRAIT_PIERCEIMMUNE) //Absorbs radiation to heal faster. Don't let it get near a reactor
	mutantlungs = /obj/item/organ/lungs/ashwalker/alpha
	burnmod = 0 //Radiation is hot, these guys are walking nuclear reactors
	brutemod = 0.3 //Good luck
	coldmod = 0.5 //Hot enough to boil the air around them
	punchdamagelow = 50
	punchdamagehigh = 75 //It's a deathclaw, it's gonna hurt
	armor = 50 //Even thicker skinned

/datum/species/lizard/deathclaw/glowing/spec_life(mob/living/carbon/human/H)
	if(H.radiation >= 1)
		H.heal_overall_damage(2,2)
		H.adjustToxLoss(-2)
		H.adjustOxyLoss(-2)
		H.adjustCloneLoss(-2)
		H.adjustStaminaLoss(-100) //Unstoppable when irradiated
		H.resize(H.size_multiplier+0.05) //Grows when nuked
		H.radiation -= 100
	else
		return ..()

//Normal Deathclaws below (Still not even attempted to balance)

/datum/species/lizard/deathclaw
	name = "Deathclaw"
	id = "deathclaw"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RADRESONANCE,TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_PIERCEIMMUNE) //Absorbs radiation to heal faster. Don't let it get near a reactor
	mutantlungs = /obj/item/organ/lungs/ashwalker/alpha
	burnmod = 0.5 //Can't light them on fire
	brutemod = 0.5 //Skin too thick for normal weapons to work
	coldmod = 0.8 //Best chance you got, good luck
	punchdamagelow = 50
	punchdamagehigh = 50 //It's a deathclaw, it's gonna hurt
	armor = 35 //Super-thick skinned

/datum/species/lizard/deathclaw/spec_life(mob/living/carbon/human/H) //Slowly heals from all injuries on their own. 
	if(H.stat == DEAD)
		return
	H.heal_overall_damage(1,1)
	H.adjustToxLoss(-1)
	H.adjustOxyLoss(-1)
