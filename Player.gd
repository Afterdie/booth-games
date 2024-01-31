extends CharacterBody2D

@export var acceleration:float = 7000
@export var friction:float = 7

@export var shotCount:int = 6
var charging:bool = false

func _ready():
	pass

func _process(delta:float) -> void:
	apply_traction(delta)
	apply_friction(delta)


func _physics_process(delta:float) -> void:
	move_and_slide()
	checkShoot()

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

func checkShoot():
	if Input.is_action_just_pressed("shoot") && $shootCooldown.is_stopped():
		shoot(0)
	if (Input.is_action_just_released("shoot") && 1):
		shoot(0)

func shoot(type:bool) -> void:
	print("shot a ball")
	const bullet = preload("res://spaceshoot/player/bullet.tscn")
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = %shootingPoint.global_position
	%shootingPoint.add_child(new_bullet)
