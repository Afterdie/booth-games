extends Node2D

func _ready():
	Engine.time_scale= 2

func _process(_delta:float):
	checkReady()
	checkStreak()

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
var counted:bool = true
var pl1
var pl2
var winner={
	"player": 0,
	"streak": 1
}
var p1hidden:bool = true
var p2hidden:bool = true

func stopGame():
	started = false

func checkStreak():
	if(!started && !counted):
		counted = true
		if(p1):
			if(winner.player!=1):
				winner.streak=1
			else:
				winner.streak+=1
			winner.player=1
		elif(p2):
			if(winner.player!=2):
				winner.streak=1
			else:
				winner.streak+=1
			winner.player=2
		updateStreak()

func updateStreak():
	$streak.text = str(winner.streak)
	if(winner.player==1):
		$streak.modulate = Color8(255,0,102)
	else:
		$streak.modulate = Color8(0,204,255)

func checkReady():
	if(Input.is_action_just_pressed("p1_shoot") && !p1):
		p1 = true
		p1hidden = false
		$panel1.modulate.a8 = 0
		var scene = load("res://spaceshoot/player/player.tscn")
		var player1 = scene.instantiate()
		player1.setId(1)
		pl1 = player1
		add_child(player1)
	
	if(Input.is_action_just_pressed("p2_shoot") && !p2):
		p2 = true
		p2hidden = false
		$panel2.modulate.a8 = 0
		var scene = load("res://spaceshoot/player/player.tscn")
		var player2 = scene.instantiate()
		player2.setId(2)
		pl2 = player2
		add_child(player2)
	
	if(!p1 && !p1hidden):
		p1hidden = true
		$panel1.modulate.a8 = 255
		counted=false
		$getResult.getVote()
	if(!p2 && !p2hidden):
		p2hidden = true
		$panel2.modulate.a8 = 255
		counted=false
		$getResult.getVote()
		
	if(p1 && p2 && !started):
		started = true
		print("Restarted")
		$beginVoting.triggerVote()
		resetShots()


func resetShots():
	pl1.resetShot()
	pl2.resetShot()

#voting triggers#
