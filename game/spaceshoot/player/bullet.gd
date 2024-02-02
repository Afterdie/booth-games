extends Area2D

@export var shotSpeed:int = 1100
var direction = Vector2(1,0)

func _physics_process(delta):
	position += direction * shotSpeed * delta

func setVelocity(passed):
	direction = passed

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
