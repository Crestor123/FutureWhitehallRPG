extends Node

@export var abilityObject : PackedScene

@export var stats : Node
@export var parent : Node

signal used_ability

func initialize(abilityList : Array[AbilityResource]):
	if !parent: parent = get_parent()
	for item in abilityList:
		var newAbility = abilityObject.instantiate()
		add_child(newAbility)
		newAbility.data = item
		newAbility.initialize()
		
func add_ability(abilityData : AbilityResource):
	var newAbility = abilityObject.instantiate()
	add_child(newAbility)
	newAbility.data = abilityData
	newAbility.initialize()
	pass
	
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
		else:
			for target in targetList:
				target.tempStats[ability.targetStat] -= damage
	
	for effect in ability.statusEffects:
		for target in targetList:
			target.Stats.add_buff(self, ability, effect)

		
	
	used_ability.emit(ability.abilityName)
	pass
