////////////////////////////////////////////////////////////////////////////////////////////////////
//										BREAST ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//Other files that are relivant:
//modular_citadel/code/datums/status_effects/chems.dm
//modular_citadel/code/modules/arousal/organs/breasts.dm

//breast englargement
//Honestly the most requested chems
//I'm not a very kinky person, sorry if it's not great
//I tried to make it interesting..!!

//Normal function increases your breast size by 0.05, 10units = 1 cup.
//If you get stupid big, it presses against your clothes, causing brute and oxydamage. Then rips them off.
//If you keep going, it makes you slower, in speed and action.
//decreasing your size will return you to normal.
//(see the status effect in chem.dm)
//Overdosing on (what is essentially space estrogen) makes you female, removes balls and shrinks your dick.
//OD is low for a reason. I'd like fermichems to have low ODs, and dangerous ODs, and since this is a meme chem that everyone will rush to make, it'll be a lesson learnt early.

/datum/reagent/fermi/breast_enlarger
	name = "Succubus milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	overdose_threshold = 17
	metabolization_rate = 0.1
	impure_chem 			= /datum/reagent/fermi/BEsmaller //If you make an impure chem, it stalls growth
	inverse_chem_val 		= 0.35
	inverse_chem		= /datum/reagent/fermi/BEsmaller //At really impure vols, it just becomes 100% inverse
	can_synth = FALSE

/datum/reagent/fermi/breast_enlarger/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(iswendigo(M))
		return
	if(!ishuman(M)) //The monkey clause
		if(volume >= 15) //To prevent monkey breast farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(T)
			var/list/seen = viewers(8, T)
			for(var/mob/S in seen)
				to_chat(S, "<span class='warning'>A pair of breasts suddenly fly out of the [M]!</b></span>")
			//var/turf/T2 = pick(turf in view(5, M))
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.Knockdown(50)
			M.Stun(50)
			B.throw_at(T2, 8, 1)
		M.reagents.del_reagent(type)
		return
	log_game("FERMICHEM: [M] ckey: [M.key] has ingested Succubus milk")
	var/mob/living/carbon/human/H = M
	H.genital_override = TRUE
	var/obj/item/organ/genital/breasts/B = H.getorganslot("breasts")
	if(!B)
		H.emergent_genital_call()
		return
	if(!B.size == "huge")
		var/sizeConv =  list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5)
		B.prev_size = B.size
		B.cached_size = sizeConv[B.size]

/datum/reagent/fermi/breast_enlarger/on_mob_life(mob/living/carbon/M) //Increases breast size
	if(!ishuman(M))//Just in case
		return..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!B) //If they don't have breasts, give them breasts.

		//If they've opted out, then route processing though liver.
		if(!(H.client?.prefs.cit_toggles & BREAST_ENLARGEMENT))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			if(L)
				//L.swelling+= 0.05 HYPER CHANGE: Liver swelling is the non-lewd equivalent of large genitals impeding movement. Feature is depreciated on Hyper.
				return..()
			else
				M.adjustToxLoss(1)
				return..()

		//otherwise proceed as normal
		var/obj/item/organ/genital/breasts/nB = new
		nB.Insert(M)
		if(nB)
			if(M.dna.species.use_skintones && M.dna.features["genitals_use_skintone"])
				nB.color = skintone2hex(H.skin_tone)
			else if(M.dna.features["breasts_color"])
				nB.color = "#[M.dna.features["breasts_color"]]"
			else
				nB.color = skintone2hex(H.skin_tone)
			nB.size = "flat"
			nB.cached_size = 0
			nB.prev_size = 0
			to_chat(M, "<span class='warning'>Your chest feels warm, tingling with newfound sensitivity.</b></span>")
			M.reagents.remove_reagent(type, 5)
			B = nB
	//If they have them, and opted in, increase size.
	if(H.client?.prefs.cit_toggles & BREAST_ENLARGEMENT)
		B.cached_size = B.cached_size + 0.05
		B.update()
	..()

/datum/reagent/fermi/breast_enlarger/overdose_process(mob/living/carbon/M) //Turns you into a female if male and ODing, doesn't touch nonbinary and object genders.
	if(!(M.client?.prefs.cit_toggles & FORCED_FEM))
		//var/obj/item/organ/liver/L = M.getorganslot("liver")
		//L.swelling+= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
		return ..()

	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	if(M.gender == MALE)
		M.gender = FEMALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more feminine!</span>", "<span class='boldwarning'>You suddenly feel more feminine!</span>")

	if(P)
		P.cached_length = P.cached_length - 0.05
		P.update()
	if(T)
		T.Remove(M)
	if(!V)
		var/obj/item/organ/genital/vagina/nV = new
		nV.Insert(M)
		V = nV
	if(!W)
		var/obj/item/organ/genital/womb/nW = new
		nW.Insert(M)
		W = nW
	..()

/datum/reagent/fermi/BEsmaller
	name = "Modesty milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary reduction via a potent estrogen mix. Produced by reacting impure Succubus milk."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	metabolization_rate = 0.25
	can_synth = FALSE

/datum/reagent/fermi/BEsmaller/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!(M.client?.prefs.cit_toggles & BREAST_ENLARGEMENT) || !B)
		//var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		//L.swelling-= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
		return ..()
	if(M.client?.prefs.cit_toggles & BREAST_ENLARGEMENT)
		B.cached_size = B.cached_size - 0.05
		B.update()
	..()

/datum/reagent/fermi/BEsmaller_hypo
	name = "Rectify milk" //Rectify
	color = "#E60584"
	taste_description = "a milky ice cream like flavour."
	metabolization_rate = 0.25
	description = "A medicine used to treat organomegaly in a patient's breasts."
	var/sizeConv =  list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5)
	can_synth = TRUE

/datum/reagent/fermi/BEsmaller_hypo/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(iswendigo(M))
		return
	if(!M.getorganslot("vagina"))
		if(M.dna.features["has_vag"])
			var/obj/item/organ/genital/vagina/nV = new
			nV.Insert(M)
	if(!M.getorganslot("womb"))
		if(M.dna.features["has_womb"])
			var/obj/item/organ/genital/womb/nW = new
			nW.Insert(M)

/datum/reagent/fermi/BEsmaller_hypo/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!B)
		return..()
	if(!M.dna.features["has_breasts"])//Fast fix for those who don't want it.
		B.cached_size = B.cached_size - 0.1
		B.update()
	else if(B.cached_size > (sizeConv[M.dna.features["breasts_size"]]+0.1))
		B.cached_size = B.cached_size - 0.05
		B.update()
	else if(B.cached_size < (sizeConv[M.dna.features["breasts_size"]])+0.1)
		B.cached_size = B.cached_size + 0.05
		B.update()
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										PENIS ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//See breast explanation, it's the same but with taliwhackers
//instead of slower movement and attacks, it slows you and increases the total blood you need in your system.
//Since someone else made this in the time it took me to PR it, I merged them.
/datum/reagent/fermi/penis_enlarger // Due to popular demand...!
	name = "Incubus draft"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a larger gentleman's package via a potent testosterone mix, formula derived from a collaboration from Fermichem  and Doctor Ronald Hyatt, who is well known for his phallus palace." //The toxic masculinity thing is a joke because I thought it would be funny to include it in the reagents, but I don't think many would find it funny? dumb
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	overdose_threshold = 17 //ODing makes you male and removes female genitals
	metabolization_rate = 0.1
	impure_chem 			= /datum/reagent/fermi/PEsmaller //If you make an inpure chem, it stalls growth
	inverse_chem_val 		= 0.35
	inverse_chem		= /datum/reagent/fermi/PEsmaller //At really impure vols, it just becomes 100% inverse and shrinks instead.
	can_synth = FALSE

/datum/reagent/fermi/penis_enlarger/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(iswendigo(M))
		return
	if(!ishuman(M)) //Just monkeying around.
		if(volume >= 15) //to prevent monkey penis farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/penis/P = new /obj/item/organ/genital/penis(T)
			var/list/seen = viewers(8, T)
			for(var/mob/S in seen)
				to_chat(S, "<span class='warning'>A penis suddenly flies out of the [M]!</b></span>")
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.Knockdown(50)
			M.Stun(50)
			P.throw_at(T2, 8, 1)
		M.reagents.del_reagent(type)
		return
	var/mob/living/carbon/human/H = M
	H.genital_override = TRUE
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!P)
		H.emergent_genital_call()
		return
	P.prev_length = P.length
	P.cached_length = P.length

/datum/reagent/fermi/penis_enlarger/on_mob_life(mob/living/carbon/M) //Increases penis size, 5u = +1 inch.
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles") //Hyper Change, testicles come first so the dick isn't hidden behind the testicles layer
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!T)//Hyper change// Adds testicles if there are none.
		if(!(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			if(L)
				//L.swelling+= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
				return..()
			else
				M.adjustToxLoss(1)
				return..()

		//otherwise proceed as normal
		var/obj/item/organ/genital/testicles/nT = new
		nT.Insert(M)
		if(nT)
			nT.size = BALLS_SIZE_MIN
			to_chat(M, "<span class='warning'>Your groin feels warm, as you feel two sensitive orbs taking shape below.</b></span>")
			nT.cached_size = 1
			nT.sack_size = BALLS_SACK_SIZE_DEF
			T = nT
	if(!P)
		if(!(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			if(L)
				//L.swelling+= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
				return..()
			else
				M.adjustToxLoss(1)
				return..()

		//otherwise proceed as normal
		var/obj/item/organ/genital/penis/nP = new
		nP.Insert(M)
		if(nP)
			nP.length = 1
			to_chat(M, "<span class='warning'>Your groin feels warm, as you feel a newly forming bulge down below.</b></span>")
			nP.cached_length = 1
			nP.prev_length = 1
			M.reagents.remove_reagent(type, 5)
			P = nP
	if(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT)
		P.cached_length = P.cached_length + 0.5
		//Hyper change// Increase ball size too
		T.size = T.size + 0.5
		T.update() //Hyper change - Make the ball size update
		P.update()
	..()

/datum/reagent/fermi/penis_enlarger/overdose_process(mob/living/carbon/M) //Turns you into a male if female and ODing, doesn't touch nonbinary and object genders.
	if(!(M.client?.prefs.cit_toggles & FORCED_MASC))
		//var/obj/item/organ/liver/L = M.getorganslot("liver")
		//L.swelling+= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
		return..()

	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	if(M.gender == FEMALE)
		M.gender = MALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more masculine!</span>", "<span class='boldwarning'>You suddenly feel more masculine!</span>")

	if(B)
		B.cached_size = B.cached_size - 0.05
		B.update()
	if(V)
		V.Remove(M)
	if(W)
		W.Remove(M)
	if(!T)
		var/obj/item/organ/genital/testicles/nT = new
		nT.Insert(M)
		T = nT
	..()

/datum/reagent/fermi/PEsmaller // Due to cozmo's request...!
	name = "Chastity draft"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a smaller gentleman's package via a potent testosterone mix. Produced by reacting impure Incubus draft."
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	metabolization_rate = 0.5
	can_synth = FALSE

/datum/reagent/fermi/PEsmaller/on_mob_life(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/penis/P = H.getorganslot("penis")
	if(!(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT) || !P)
		//var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		//L.swelling-= 0.05 //HYPER CHANGE: See comment in /breast_enlarger/on_mob_life()
		return..()
	if(H.client?.prefs.cit_toggles & PENIS_ENLARGEMENT)
		P.cached_length = P.cached_length - 0.1
		P.update()
	..()

/datum/reagent/fermi/PEsmaller_hypo
	name = "Rectify draft"
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	description = "A medicine used to treat organomegaly in a patient's penis."
	metabolization_rate = 0.5
	can_synth = TRUE

/datum/reagent/fermi/PEsmaller_hypo/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(iswendigo(M))
		return
	if(!M.getorganslot("testicles"))
		if(M.dna.features["has_balls"])
			var/obj/item/organ/genital/testicles/nT = new
			nT.Insert(M)

/datum/reagent/fermi/PEsmaller_hypo/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!P)
		return ..()
	if(!M.dna.features["has_cock"])//Fast fix for those who don't want it.
		P.cached_length = P.cached_length - 0.2
		P.update()
	else if(P.cached_length > (M.dna.features["cock_length"]+0.1))
		P.cached_length = P.cached_length - 0.1
		P.update()
	else if(P.cached_length < (M.dna.features["cock_length"]+0.1))
		P.cached_length = P.cached_length + 0.1
		P.update()
	..()



///Ass enhancer

/datum/reagent/fermi/butt_enlarger
	name = "Denbu Draft"
	description = "A mixture of natural vitamins and valentines plant extract, causing butt enlargement on mammals."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "butter with a sweet aftertaste" //pass me the butter, OM NOM
	overdose_threshold = 17
	can_synth = FALSE

/datum/reagent/fermi/butt_enlarger/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(iswendigo(M))
		return
	log_game("FERMICHEM: [M] ckey: [M.key] has ingested Butt enhancer")
	var/mob/living/carbon/human/H = M
	H.genital_override = TRUE
	var/obj/item/organ/genital/anus/B = H.getorganslot("anus")
	if(!B)
		return

/datum/reagent/fermi/butt_enlarger/on_mob_life(mob/living/carbon/M) //Increases butt size
	if(!ishuman(M))//Just in case
		return..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/anus/B = M.getorganslot("anus")
	if(!B) //If they don't have a butt and are opted in, give them one!
		if(H.client?.prefs.cit_toggles & ASS_ENLARGEMENT)
			var/obj/item/organ/genital/anus/nB = new
			nB.Insert(M)
			if(nB)
				if(M.dna.species.use_skintones && M.dna.features["genitals_use_skintone"])
					nB.color = skintone2hex(H.skin_tone)
				else if(M.dna.features["breasts_color"])
					nB.color = "#[M.dna.features["breasts_color"]]"
				else
					nB.color = skintone2hex(H.skin_tone)
				nB.size = 1
				to_chat(M, "<span class='warning'>Your ass cheeks bulge outwards and feel heavier.</b></span>")
				M.reagents.remove_reagent(type, 5)
				B = nB
	//If they have & opt in, increase size.
	if(H.client?.prefs.cit_toggles & ASS_ENLARGEMENT)
		if(B.size < BUTT_MAX_SIZE) //just make sure you dont break sprites
			B.size = B.size + 0.05
			B.update()
	..()
