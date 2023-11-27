class_name Fish extends Node2D

@export var movement_speed = 4
@export var movement_time = 1

@export var min_distance = 20
@export var max_distance = 150

# Pretty sure these are what handle the fish being between two points LOL.
# It is.
@export var lower_boundary = 0
@export var upper_boundary = 200

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	plan_move()

func _process(delta):
	_animated_sprite.play("default")

func plan_move():
	var target = randf_range(lower_boundary, upper_boundary)
#	var target = upper_boundary 
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
#		target = upper_boundary
		target = randf_range(lower_boundary, upper_boundary)
		
	move(Vector2(self.position.x, target))

func move(target):
	var tween = create_tween()
	tween.tween_property(self, "position", target, movement_speed).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	$MoveTimer.set_wait_time(movement_time)
	$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	_animated_sprite.stop()
	queue_free()
	
func timeout():
	plan_move()
