extends EquipNode

class_name FirearmNode

@export var chargePerShot : int
@export var totalCharge : int
@export var ShootAbility : AbilityResource
@export var ReloadAbility : AbilityResource

var currentCharge : int = 0

func initialize():
	super.initialize()
	slot = "weapon"
	
	abilities.append(ShootAbility)
	abilities.append(ReloadAbility)
	
	chargePerShot = data.chargePerShot
	totalCharge = data.totalCharge
