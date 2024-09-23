extends Node

@export var abilityObject : PackedScene

@export var stats : Node
@export var parent : Node
@export var equipment : Node

signal used_ability

func initialize(abilityList : Array[AbilityResource]):
	if !parent: parent = get_parent()
	for item in abilityList:
		add_ability(item)
		
func add_ability(abilityData : AbilityResource, source : Node = null):
	var newAbility = abilityObject.instantiate()
	add_child(newAbility)
	newAbility.data = abilityData
	newAbility.initialize(source)
	
	if newAbility.ammoCost > 0:
		if source and source is FirearmNode:
			newAbility.realAmmoCost = newAbility.ammoCost * source.chargePerShot
		elif equipment:
			newAbility.realAmmoCost = newAbility.ammoCost * equipment.get_charge_cost()
	
func remove_ability(abilityData : AbilityResource, source : Node = null):
	for i in get_children():
		if i.data == abilityData and i.source == source:
			i.queue_free()
			break
	
func has_ability(abilityData : AbilityResource, source : Node = null):
	for i in get_children():
		if i.data == abilityData:
			if source and i.source == source:
				return true
			elif !source:
				return true
			break
	return false
	pass
	
func use_ability(ability : Node, targetList : Array[Node]):
	print(ability.abilityName)
	if ability not in get_children():
		print("Error: no such ability")
	
	var damage = 0
	damage = (ability.baseDamage + stats.get_stat(ability.mainStat)) * ability.multiplier
	if ability.realAmmoCost > 0:
		damage = (ability.baseDamage) * ability.realAmmoCost * ability.multiplier
	
	if targetList == null:
		print("Error: no target found")
	
	if ability.target == "self":
		targetList.clear()
		targetList.append(parent)
		
	if ability.baseDamage > 0:
		for target in targetList:
			if accuracy_roll(target):
				if ability.targetStat == "health":
					target.Stats.take_damage(damage, ability.type, ability.element)
				elif ability.targetStat == "mana":
					target.tempStats["mana"] -= damage
				for effect in ability.statusEffects:
					target.Stats.add_buff(self, ability, effect)
					
	if ability.baseDamage < 0:
		for target in targetList:
			target.Stats.heal(damage)
			for effect in ability.statusEffects:
				if effect.status == "reload":
					if ability.source:
						equipment.reload(ability.source)
				else:
					target.Stats.add_buff(self, ability, effect)
	
	if ability.realAmmoCost > 0:
		parent.Equipment.spend_charge(ability.realAmmoCost)
	if ability.manaCost > 0:
		parent.Stats.spend_mana(ability.manaCost)
		
	
	used_ability.emit(ability.abilityName)
	pass
	
func accuracy_roll(target) -> bool:
	#Roll to hit using dexterity
	var dex = stats.get_stat("dexterity") - target.Stats.get_stat("dexterity")
	print(dex)
	return true
