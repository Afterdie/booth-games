extends CharacterBody2D

@export var acceleration:float = 7000
@export var friction:float = 7

@export var shotCount:int = 6 #changes in real time
var startingShots:int = 0 #changes when charging starts

@export var regenCooldown:float = 2 #stores the duration between each bulllet
@onready var timer = $regenCooldown

var charging:bool = false #state machine
@onready var chargeTimer = $chargeTimer

func _ready():
	pass

func _process(delta:float) -> void:
	updateAmmo()
	apply_traction(delta)
	apply_friction(delta)


func _physics_process(delta:float) -> void:
	updateShot()
	move_and_slide()
	checkShoot()
	shotRegen()

 #-------------------Movement Logic-------------------#

func apply_traction(delta:float) -> void:
	var traction: Vector2 = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		traction.y -= 1
	if Input.is_action_pressed("ui_down"):
		traction.y += 1
	if Input.is_action_pressed("ui_left"):
		traction.x -= 1
	if Input.is_action_pressed("ui_right"):
		traction.x += 1
	traction = traction.normalized()
	velocity += traction * acceleration * delta

func apply_friction(delta:float) -> void:
	velocity -= velocity * friction * delta

 #-------------------Shooting Logic-------------------#

#updates the lable for ammo
func updateAmmo():
	%score.text = str(shotCount)

#check if the shoot button has been clicked
func checkShoot():
	if(Input.is_action_just_pressed("shoot") && shotCount>0):
		startingShots = shotCount
		charging=true
		chargeTimer.start(shotCount)

	if(Input.is_action_just_released("shoot")):
		print(startingShots-floor(chargeTimer.time_left))
		charging=false
		shoot(startingShots - floor(chargeTimer.time_left))
	#add logic for charged shot

func updateShot():
	if(charging):
		shotCount = chargeTimer.time_left

#regen the bullets
func shotRegen():
	if(shotCount<6 && timer.is_stopped() && !charging):
		timer.start(regenCooldown)

func _on_shoot_cooldown_timeout():
	shotCount+=1

#called when the checkshoot sees that button has been pressed
func shoot(power:int):
	print("shot" ,power, " balls")
	if (shotCount>0):
		const bullet = preload("res://spaceshoot/player/bullet.tscn")
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = %shootingPoint.global_position
		%shootingPoint.add_child(new_bullet)
