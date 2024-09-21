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
		
func add_ability(abilityData : AbilityResource):
	var newAbility = abilityObject.instantiate()
	add_child(newAbility)
	newAbility.data = abilityData
	newAbility.initialize()
	
	if newAbility.ammoCost > 0:
		if equipment:
			newAbility.ammoCost = newAbility.ammoCost * equipment.get_charge_cost()
	pass
	
func remove_ability(abilityData : AbilityResource):
	for i in get_children():
		if i.data == abilityData:
			i.queue_free()
			break
	
func use_ability(ability : Node, targetList : Array[Node]):
	print(ability.abilityName)
	if ability not in get_children():
		print("Error: no such ability")
	
	var damage = 0
	damage = (ability.baseDamage + stats.get_stat(ability.mainStat)) * ability.multiplier
	
	if targetList == null:
		print("Error: no target found")
	
	if ability.target == "self":
		targetList.clear()
		targetList.append(parent)
		
	if ability.baseDamage > 0:
		if ability.targetStat == "health":
			for target in targetList:
				target.Stats.take_damage(damage, ability.type, ability.element)
		elif ability.targetStat == "mana":
			for target in targetList:
				target.tempStats["mana"] -= damage
	
	for effect in ability.statusEffects:
		for target in targetList:
			target.Stats.add_buff(self, ability, effect)
	
	if ability.ammoCost > 0:
		parent.Equipment.spend_charge(ability.ammoCost)
	if ability.manaCost > 0:
		parent.Stats.spend_mana(ability.manaCost)
		
	
	used_ability.emit(ability.abilityName)
	pass
