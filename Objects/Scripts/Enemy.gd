extends Node2D

@onready var Sprite = $Sprite2D
@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Select = $Sprite2D/Button
@onready var HealthBar = $HealthBar
@onready var DamageNumber = $DamageNumber
@onready var Anim = $AnimationPlayer

@export var data : EnemyResource

var enemyName : String = ""
var level : int
var experience : int
var icon : Texture2D = null
var playingAnimation = false

var itemDrops : Dictionary

var targets : Array[Node]
var allies : Array[Node]

signal on_select
signal animationFinished
signal dead
signal revived
signal endTurn

func initialize():
	if !data: return
	
	enemyName = data.name
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
	itemDrops = data.itemDrops
	Sprite.texture = data.sprite
	icon = data.sprite
	
	
	Stats.reviveSignal.connect(revive)
	Stats.healthChanged.connect(update_healthbar)
	Stats.takeDamage.connect(take_damage)
	Stats.healthZero.connect(die)

func start_turn(turnCount):
	Stats.tick_buffs()
	for item in Stats.get_children():
		if item.disabling == true:
			#The battler is prevented from acting
			return
	
	var ability = select_ability(turnCount)
	var targetArray = select_target(ability)
	Abilities.use_ability(ability, targetArray)
	
func end_turn(abilityName = ""):
	endTurn.emit()
	
#Uses turn count to choose an ability (implement some AI later)
func select_ability(turnCount) -> Node:
	return Abilities.get_child(turnCount % Abilities.get_child_count())
	pass

#Chooses a target for the current ability
func select_target(ability):
	var aliveTargets : Array[Node]
	for item in targets:
		if !item.Stats.dead: aliveTargets.append(item)
	
	if ability.target == "multi":
		return aliveTargets
	
	var targetIndex = randi_range(0, aliveTargets.size() - 1)
	var targetArray : Array[Node] = [aliveTargets[targetIndex]]
	return targetArray
	pass

func take_damage(amount):
	DamageNumber.text = str(amount) 
	DamageNumber.visible = true
	playingAnimation = true
	Anim.play("damageNumber")
	playingAnimation = false
	animationFinished.emit()
	pass

func update_healthbar():
	HealthBar.update_bar(Stats.get_health(true))
	animationFinished.emit()
	pass

#Enemy selector button signal
func _on_button_pressed():
	on_select.emit(self)

func revive():
	print(name, " revived!")
	Stats.dead = false
	Sprite.visible = true
	revived.emit(self)

func die():
	print(name, " defeated!")
	Stats.dead = true
	Sprite.visible = false
	dead.emit(self)
	pass
