extends Node2D

@export var id:int

# Called when the node enters the scene tree for the first time.
func _ready():
	setUI()

func setUI():
	var idle = $Idle
	var label = $id
	if(id==1):
		idle.modulate = Color8(255,0,102)
		label.text = ("P%s" %id)
	else:
		idle.modulate = Color8(0,204,255)
		label.text = ("P%s" %id)

func _process(delta):
	pass
