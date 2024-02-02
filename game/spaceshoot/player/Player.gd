extends CharacterBody2D

#Movement Variables#
@export var acceleration:float = 7000
@export var friction:float = 7

#Shooting Variables#
@export var shotCount:int = 6 #changes in real time
var curShot:int = shotCount #manipulation in code

var charging:bool = false #charging flag
@export var regenCooldown:float = 2 #duration between each bulllet regen
@onready var timer = $regenCooldown #timer for the bulllt regen
@onready var chargeTimer = $chargeTimer #how long has the shoot btn been held down
var tempShot:int = 6 #for visual purposes


func _ready():
	pass

func _process(delta:float) -> void:
	updateShot()
	apply_traction(delta)
	apply_friction(delta)

func _physics_process(delta:float) -> void:
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

#check if the shoot button has been clicked
func checkShoot():
	if(Input.is_action_just_pressed("shoot") && curShot>0):
		charging = true
		chargeTimer.start(curShot)
	if(Input.is_action_just_released("shoot")):
		charging = false
		shoot(curShot-floor(chargeTimer.time_left))
		chargeTimer.stop()

#called after button released
func shoot(power:int):
	print(power, " balls")
	if(curShot>0):
		const bullet = preload("res://spaceshoot/player/bullet.tscn")
		var new_bullet = bullet.instantiate()
		new_bullet.scale += Vector2(power,power)*0.7
		new_bullet.global_position = %shootingPoint.global_position
		%shootingPoint.add_child(new_bullet)
		curShot-=power

#update ui element
func updateShot():
	tempShot = chargeTimer.time_left
	if(charging):
		%score.text = str(tempShot)
	else:
		%score.text = str(curShot)

#regen logic
func shotRegen():
	if(charging):
		timer.stop()
	if(curShot<6 && timer.is_stopped()):
		timer.start(regenCooldown)

func _on_shoot_cooldown_timeout():
	print("added one bullet")
	curShot+=1
