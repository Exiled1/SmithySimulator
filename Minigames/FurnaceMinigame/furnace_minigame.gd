extends Node2D

var hookVelocity := 0
var hookAcceleration := .1
var hookDeceleration := .2
var maxVelocity := 6.0
var bounce := .6

var fishable = true
func _process(delta: float):
# Called when the node enters the scene tree for the first time.
	var bar_top = $Top.global_position
	var bar_bottom = $Bottom.global_position
	var fish := $Fish as Fish
	
#	fish.max_position = $FishingColumn/Top.position.y
#	fish.min_position = $FishingColumn/Bottom.position.y
	
	# Hopefully this code slows down the hook as we go up with the primary
	# action.
	if Input.is_action_pressed("primary_action"):
		if hookVelocity > -maxVelocity:
			hookVelocity -= hookAcceleration
	else:
		if hookVelocity < maxVelocity:
			hookVelocity += hookDeceleration
	# Don't make the hook movement instant.
	if Input.is_action_just_pressed("primary_action"):
		hookVelocity -= .5
	var target = $Hook.position.y + hookVelocity
	if (target >= $FishingColumn/Top.position.y):
		hookVelocity *= -bounce
	elif (target <= $FishingColumn/Bottom.position.y + 38):
		hookVelocity = 0
		$Hook.position.y = $FishingColumn/Bottom.position.y + 38
	else:
		$Hook.position.y = target
	
	# Adjust Value
	if (fishable == false):
		if (len($Hook/Area2D.get_overlapping_areas()) > 0):
			$Node2D/Progress.value += 125 * delta
			if ($Node2D/Progress.value >= 999):
				caught_fish()
		else:
			$Node2D/Progress.value -= 100 * delta
			if ($Node2D/Progress.value <= 0):
				lost_fish()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	
	pass

func caught_fish():
	$Fish.destroy()
#	$Message.text = "Caught one!"
#	$MessageTimer.set_wait_time(3);
#	$MessageTimer.start()
#	$Progress.value = 0
	fishable = true
	
func lost_fish():
	$Fish.destroy()
#	$Message.text = "Next time!"
#	$MessageTimer.set_wait_time(3);
#	$MessageTimer.start()
#	$Progress.value = 0
	fishable = true
