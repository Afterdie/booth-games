extends Node2D

func _ready():
	Engine.time_scale= 2

func _process(_delta:float):
	checkReady()
	checkStreak()
	voteCheck()

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
var streakData={
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
			if(streakData.player!=1):
				streakData.streak=1
			else:
				streakData.streak+=1
			streakData.player=1
			print(streakData.player)
		elif(p2):
			if(streakData.player!=2):
				streakData.streak=1
			else:
				streakData.streak+=1
			streakData.player=2
		updateStreak()

func updateStreak():
	$streak.text = str(streakData.streak)
	if(streakData.player==1):
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
	if(!p2 && !p2hidden):
		p2hidden = true
		$panel2.modulate.a8 = 255
		counted=false
		
	if(p1 && p2 && !started):
		started = true
		print("Restarted")
		resetShots()


func resetShots():
	pl1.resetShot()
	pl2.resetShot()

var eventType = [
	"Infinite",
	"Laser"
]

var isVotingTimer:bool = false

func voteCheck():
	if(started && !isVotingTimer):
		isVotingTimer = true
		$voteTimer.start()

func _on_vote_timer_timeout():
	#add logic to randomise between events
	$beginVoting.triggerVote(eventType[0])
	await get_tree().create_timer(10).timeout
	onVoteEnd()

func onVoteEnd():
	isVotingTimer = false
	$voteTimer.wait_time=20
	$getResult.getVote()

func handleEvent(json):
	if(!started): return
	if(json.winnerCode==0):
		laserEvent()
		return
	if(json.type=="Infinite"):
		infEvent(json.winnerCode)

func laserEvent():
	var scene = load("res://spaceshoot/level/laser.tscn")
	var laser = scene.instantiate()
	var pos:float = randf_range(220, 500)
	print("added laser at ", pos)	
	laser.setPosition(pos)
	laser.z_index = 0
	add_child(laser)
	var eventTimer = $eventTimer
	eventTimer.start()
	eventTimer.timeout.connect(func(): laser.queue_free())

func infEvent(id):
	if(id==0):
		return
	elif(id==1):
		pl1.setInfEvent()
	elif(id==-1):
		pl2.setInfEvent()
	var eventTimer = $eventTimer
	await get_tree().create_timer(10).timeout
	if(id==1): 
			pl1.setInfEvent()
	elif(id==-1):
			pl2.setInfEvent()
