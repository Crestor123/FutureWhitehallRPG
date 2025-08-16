class_name Battler extends Node2D

@onready var Sprite = $Sprite2D
@onready var Stats = $StatComponent
@onready var Abilities = $AbilityComponent
@onready var btnSelect = $Sprite2D/Button
@onready var HealthBar = $HealthBar
@onready var DamageNumber = $DamageNumber
@onready var Anim = $AnimationPlayer
@onready var SpriteAnim = $Sprite2D/AnimationPlayer
@onready var ButtonTimer = $Sprite2D/Button/Timer

signal on_select
signal battlerReady
signal animationFinished
signal selectedAbility
signal analyzed
signal dead
signal revived
signal endTurn

var Name: String = ""
var icon : Texture2D = null
var playingAnimation = false
var playingSpriteAnimation = false

func initialize():
	Stats.reviveSignal.connect(revive)
	Stats.healthChanged.connect(update_healthbar)
	Stats.takeDamage.connect(take_damage)
	Stats.healthZero.connect(die)
	ButtonTimer.timeout.connect(analyze)
	pass
	
func start_turn(turnCount: int):
	Stats.tick_buffs()
	for item in Stats.get_children():
		if item.disabling == true:
			#The battler is prevented from acting
			return
	pass
	
func end_turn(abilityName: String = ""):
	endTurn.emit()
	
func take_damage(amount: int):
	DamageNumber.text = str(amount) 
	DamageNumber.visible = true
	playingAnimation = true
	playingSpriteAnimation = true
	
	Anim.play("damageNumber")
	SpriteAnim.play("HitFlash")
	pass
	
func ready_check():
	if playingAnimation == false:
		battlerReady.emit(self)

func update_healthbar(amount):
	HealthBar.update_bar(Stats.get_health(true))
	animationFinished.emit()
	pass

func analyze():
	analyzed.emit(self)
	
#Button signals: When held down, emit the analyzed signal
func _on_button_down():
	ButtonTimer.start(0)
	pass
	
func _on_button_up():
	ButtonTimer.stop()
	
func revive():
	print(Name, " revived!")
	Stats.dead = false
	revived.emit(self)
	pass
	
func die():
	print(Name, " defeated!")
	Stats.dead = true
	dead.emit(self)
	pass

func _on_sprite_animation_started(anim_name):
	playingSpriteAnimation = true
	
func _on_battler_animation_started(anim_name):
	playingAnimation = true

func _on_sprite_animation_finished(anim_name):
	playingSpriteAnimation = false
	animation_finished()

func _on_battler_animation_finished(anim_name):
	playingAnimation = false
	animation_finished()

func animation_finished():
	if playingAnimation or playingSpriteAnimation:
		return
	print(Name, " finished animation")
	animationFinished.emit()
	battlerReady.emit(self)
	pass
