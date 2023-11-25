extends Node2D

var hookVelocity :float = 0.0
@export var hookAcceleration := .07
@export var hookDeceleration := .12
@export var maxVelocity := 2.5
@export var bounce := .6
var fish = preload("res://Minigames/FurnaceMinigame/fish.tscn")
var fishable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	spawn_easy()
#	fish = $Fish
	
	
	

func _process(delta):
	if Input.is_action_pressed("primary_action"):
		if hookVelocity > -maxVelocity:
			hookVelocity -= hookAcceleration
	else:
		if hookVelocity < maxVelocity:
			hookVelocity += hookDeceleration
			
	if (Input.is_action_just_pressed("primary_action")):
		hookVelocity -= .2
		
	var target = $Hook.position.y + hookVelocity
	if (abs(target) <= abs($Bottom.position.y)): # This is code to detect if the target is below the bounds. Its negative because the whole damn thing is upside down.
		hookVelocity *= -bounce
	elif (abs(target) >= abs($Top.position.y)): # 28 is the # of pixels from the top to the center of the hook. Fml.
		hookVelocity = 0
		$Hook.position.y = $Top.position.y
	else:
		$Hook.position.y = target
		
	# Adjust Value
	if (fishable == false):
		if (len($Hook/FishChecker.get_overlapping_areas()) > 0):
			$Progress.value += 125 * delta
			if ($Progress.value >= 999):
				caught_fish()
		else:
			$Progress.value -= 100 * delta
			if ($Progress.value <= 0):
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
	f.position = Vector2(0, -143.75)
#	fish.position = Vector2(0, -143.75) # -143.75 cuz thats the center of the fuckin thing. I dont want to figure out the distance, so be careful changing the size of the fishing minigame.
	# You'll have to do it again.
	f.upper_boundary = $Top.position.y
	f.lower_boundary = $Bottom.position.y

	f.min_distance = min_d
	f.max_distance = max_d
	f.movement_speed = move_speed
	f.movement_time = move_time
	
	add_child(f)
	$Progress.value = 200
	fishable = false

func spawn_easy():
	if (fishable):
		add_fish(10, 40, 8, 3)
		fishable = false
