extends Node2D

func _ready():
	Engine.time_scale= 2

func _process(_delta:float):
	checkReady()

func setScreen(val:int):
	if(val==1):
		$panel1.modulate.a8 = 255
		p1 = false
	if(val==2):
		$panel2.modulate.a8 = 255
		p2 = false

#Ready Logic
var p1:bool = false
var p2:bool = false
var started:bool = false
var pl1
var pl2

func stopGame():
	started = false

func checkReady():
	if(Input.is_action_just_pressed("p1_shoot") && !p1):
		p1 = true
		$panel1.modulate.a8 = 0
		var scene = load("res://spaceshoot/player/player.tscn")
		var player1 = scene.instantiate()
		player1.setId(1)
		pl1 = player1
		add_child(player1)
	
	if(Input.is_action_just_pressed("p2_shoot") && !p2):
		p2 = true
		$panel2.modulate.a8 = 0
		var scene = load("res://spaceshoot/player/player.tscn")
		var player2 = scene.instantiate()
		player2.setId(2)
		pl2 = player2
		add_child(player2)
	
	if(!p1):
		$panel1.modulate.a8 = 255
	if(!p2):
		$panel2.modulate.a8 = 255
		
	if(p1 && p2 && !started):
		started = true
		print("Restarted")
		resetShots()


func resetShots():
	pl1.resetShot()
	pl2.resetShot()
