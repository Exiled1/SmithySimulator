class_name Fish extends Node2D

@export var movement_speed = 4
@export var movement_time = 1

@export var min_distance = 100
@export var max_distance = 200

# Pretty sure these are what handle the fish being between two points LOL.
@export var min_position = 20
@export var max_position = 290

# Called when the node enters the scene tree for the first time.
func _ready():
	plan_move()
	
func plan_move():
	var target = randf_range(min_position, max_position)
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		target = randf_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

func move(target):
	var tween = create_tween()
	tween.tween_property(self, "position", target, movement_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	$MoveTimer.set_wait_time(movement_time)
	$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	queue_free()
	
func timeout():
	plan_move()
