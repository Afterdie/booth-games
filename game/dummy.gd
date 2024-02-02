extends CharacterBody2D

var hp:int = 100

func take_damage(value):
	print("took ",value, " damage")
	hp-=value

func _process(delta:float):
	$Label.text = str(hp," hp")
