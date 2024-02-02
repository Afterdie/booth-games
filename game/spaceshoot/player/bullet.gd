extends Area2D

@export var shotSpeed:int = 1
var direction = Vector2(1,0)
var ap:int

func _ready():
	shotSpeed*=1500

func _physics_process(delta):
	position += direction * shotSpeed * delta

func setVelocity(passed):
	direction = passed

func setAp(value):
	ap=value*10

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(ap)
