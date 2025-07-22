class_name EnemyBattler extends Battler

@export var data : EnemyResource

var suffix : String = ""
var level : int
var experience : int

var moneyDrop : int
var itemDrops : Dictionary

var targets : Array[Battler]
var allies : Array[Battler]

func initialize():
	super.initialize()
	
	if !data: return
	
	Name = data.name
	level = data.level
	experience = data.experience
	
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	Stats.tempStats["health"] = Stats.stats["health"]
	Stats.tempStats["mana"] = Stats.stats["mana"]
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
		
	Abilities.initialize(data.abilities)
	Abilities.used_ability.connect(end_turn)
	moneyDrop = data.moneyDrop
	itemDrops = data.itemDrops
	Sprite.texture = data.sprite
	icon = data.sprite

func start_turn(turnCount: int):
	super.start_turn(turnCount)
	
	var ability = select_ability(turnCount)
	selectedAbility.emit(ability.abilityName)
	var targetArray = select_target(ability)
	Abilities.use_ability(ability, targetArray)


#Uses turn count to choose an ability (implement some AI later)
func select_ability(turnCount: int) -> Node:
	return Abilities.get_child(turnCount % Abilities.get_child_count())
	pass
	
#Chooses a target for the current ability
func select_target(ability: Node):
	var aliveTargets : Array[Battler]
	for item in targets:
		if !item.Stats.dead: aliveTargets.append(item)
	
	if ability.target == "multi":
		return aliveTargets
	
	var targetIndex = randi_range(0, aliveTargets.size() - 1)
	var targetArray : Array[Node] = [aliveTargets[targetIndex]]
	return targetArray
	pass
	
func revive():
	Sprite.visible = true
	super.revive()
	
func die():
	Sprite.visible = false
	super.die()
	pass
