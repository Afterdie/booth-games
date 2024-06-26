extends CharacterBody2D

@export var id:int

#Movement Variables#
@export var acceleration:float = 3500
@export var friction:float = 7

#Shooting Variables#
@export var shotCount:int = 6 #changes in real time
var curShot:int = shotCount #manipulation in code

var charging:bool = false #charging flag
@export var regenCooldown:float = 2 #duration between each bulllet regen
@onready var timer = $regenCooldown #timer for the bulllt regen
@onready var chargeTimer = $chargeTimer #how long has the shoot btn been held down
var tempShot:int = 6 #for visual purposes

@export var shootingDeviation:int = 1

#HP variables
@export var hp:int = 100
var powerUp = false

func setId(val:int):
	id=val
	setPos(val)

func setPos(val:int):
	if(val==1):
		position = Vector2(320,360)
	if(val==2):
		position = Vector2(960,360)
		scale.x *= -1

func _ready():
	shootingDeviation*=5000
	if(id==1):
		characterHp.modulate = Color8(255,0,102)
	else:
		characterHp.modulate = Color8(0,204,255)

func _process(delta:float) -> void:
	if(curShot>6): #if for some reason it exceeds
		curShot=6
	#dev tools
	if(Input.is_action_just_pressed("dev")):
		curShot = 6
	
	updateShot()
	apply_traction(delta)
	apply_friction(delta)

func _physics_process(_delta:float) -> void:
	move_and_slide()
	checkShoot()
	shotRegen()

 #-------------------Movement Logic-------------------#

func apply_traction(delta:float) -> void:
	var traction: Vector2 = Vector2()
	
	if Input.is_action_pressed("p%s_up" %id):
		traction.y -= 1
	if Input.is_action_pressed("p%s_down" %id):
		traction.y += 1
	if Input.is_action_pressed("p%s_left" %id):
		traction.x -= 1
	if Input.is_action_pressed("p%s_right" %id):
		traction.x += 1
	traction = traction.normalized()
	velocity += traction * acceleration * delta

func apply_friction(delta:float) -> void:
	velocity -= velocity * friction * delta

 #-------------------Shooting Logic-------------------#

#check if the shoot button has been clicked
func checkShoot():
	if(Input.is_action_just_pressed("p%s_shoot" %id) && curShot>0):
		#print("started charging with ",curShot," balls")
		charging = true
		$dmgAnim.play("charge")
		chargeTimer.start(curShot)
	if(Input.is_action_just_released("p%s_shoot" %id) && charging):
		charging = false
		$dmgAnim.stop()
		shoot(curShot-floor(chargeTimer.time_left))
		chargeTimer.stop()

func setInfEvent():
	powerUp = !powerUp
	print(powerUp)

#called after button released
func shoot(power:int):
	#print(power, " balls")
	if(curShot>0 && power>0):
		if(powerUp): 
			power = 1
		const bullet = preload("res://spaceshoot/player/bullet.tscn")
		var new_bullet = bullet.instantiate()
		new_bullet.scale += Vector2(power,power)*0.7
		
		new_bullet.global_position = %shootingPoint.global_position
		var yComp:float = 0.0 + velocity.y/shootingDeviation
		var xComp:float
		if(id==1):
			xComp = 1
		else:
			xComp = -1
		new_bullet.setVelocity(Vector2(xComp,yComp))
		new_bullet.setAp(power)
		%shootingPoint.add_child(new_bullet)
		if(!powerUp): 
			curShot-=power

#update ui element
func updateShot():
	tempShot = chargeTimer.time_left
	if(charging && !powerUp):
		$characterOutline.region_rect.position.x = 600*(6-tempShot)
	else:
		$characterOutline.region_rect.position.x = 600*(6-curShot)
	if(powerUp):
		$characterOutline.region_rect.position.x = 600*7

#regen logic
func shotRegen():
	if(charging):
		timer.stop()
	if(curShot<6 && timer.is_stopped()):
		timer.start(regenCooldown)

func _on_shoot_cooldown_timeout():
	curShot+=1

#-------------------Health Logic-------------------#

@onready var characterHp = $characterHp

func take_damage(ap:int):
	characterHp.modulate.a8 -= 255/10
	hp-=ap
	$dmgAnim.play("damage")
	$dmgSFX.play()
	if(hp<=0):
		#$deathSFX.play()
		death()

func death():
	print("p%s lost" %id)
	get_parent().setScreen(id)
	get_parent().stopGame()
	queue_free()

func resetShot():
	curShot=6
