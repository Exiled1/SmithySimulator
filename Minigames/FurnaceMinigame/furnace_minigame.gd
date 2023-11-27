extends Node2D

var hookVelocity :float = 0.0
@export var hookAcceleration := 5
@export var hookDeceleration := 5
@export var maxVelocity := 20
@export var bounce := 4
var fish = preload("res://Minigames/FurnaceMinigame/fish.tscn")
var fishable = true
var center_of_minigame
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var x1 = %Top.position.x
	var y1 = %Top.position.y
	var x2 = %Bottom.position.x
	var y2 = %Bottom.position.y
	center_of_minigame = Vector2((x1+x2)/2, (y1+y2)/2)
	%Hook.position = %Bottom.position
	spawn_easy()

	
	
	

func _process(delta):
	if Input.is_action_pressed("primary_action"):
		if hookVelocity > -maxVelocity:
			hookVelocity -= hookAcceleration * delta
	else:
		if hookVelocity < maxVelocity:
			hookVelocity += hookDeceleration * delta
			
	if (Input.is_action_just_pressed("primary_action")):
		hookVelocity -= .2 * delta
		
	var target = %Hook.position.y + hookVelocity
	# I can probably take off the abs val since itll mess it up later.
	if (abs(target) >= abs(%Bottom.position.y)): # This is code to detect if the target is below the bounds. Its negative because the whole damn thing is upside down.
		hookVelocity *= -bounce * delta
	elif (abs(target) <= abs(%Top.position.y)): # 28 is the # of pixels from the top to the center of the hook. Fml.
		hookVelocity = 0
		%Hook.position.y = %Top.position.y 
	else:
		%Hook.position.y = target
		
	# Adjust Value
	if (fishable == false):
		if (len(%Hook/FishChecker.get_overlapping_areas()) > 0):
			%FishingProgress.value += 125 * delta
			if (%FishingProgress.value >= 999):
				caught_fish()
		else:
			%FishingProgress.value -= 100 * delta
			if (%FishingProgress.value <= 0):
				lost_fish()





func caught_fish():
	$Fish.destroy()
#	$Message.text = "Caught one!"
#	$MessageTimer.set_wait_time(3);
#	$MessageTimer.start()
#	$Progress.value = 0
	fishable = true
	
func lost_fish():
	$Fish.destroy()
	print("Should happen rn")
#	$Message.text = "Next time!"
#	$MessageTimer.set_wait_time(3);
#	$MessageTimer.start()
#	$Progress.value = 0
	fishable = true



func add_fish(min_d, max_d, move_speed, move_time):
	var f = fish.instantiate()
	f.position = center_of_minigame
#	fish.position = Vector2(0, -143.75) # -143.75 cuz thats the center of the fuckin thing. I dont want to figure out the distance, so be careful changing the size of the fishing minigame.
	# You'll have to do it again.
	f.upper_boundary = %Top.position.y
	f.lower_boundary = %Bottom.position.y

	f.min_distance = min_d
	f.max_distance = max_d
	f.movement_speed = move_speed
	f.movement_time = move_time
	
	add_child(f)
	%FishingProgress.value = 200
	fishable = false

func spawn_easy():
	if (fishable):
		add_fish(10, 40, 8, 3)
		fishable = false
