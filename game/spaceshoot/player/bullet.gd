extends Area2D

@export var shotSpeed:int = 1100
var direction = Vector2(1,0)
var ap:int

func _physics_process(delta):
	position += direction * shotSpeed * delta

func setVelocity(passed):
	direction = passed
	scale.x = passed.x

func setAp(value):
	ap=value*10

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(ap)
