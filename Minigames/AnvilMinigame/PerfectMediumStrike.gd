extends Node2D

@export var perfect_hit_percent: float
@export var medium_hit_percent: float
var width_of_bar: float
var height_of_bar: float

# Called when the node enters the scene tree for the first time.
func _ready():
	var bg_texture: Texture2D = %Background.texture
	height_of_bar = bg_texture.get_height()
	width_of_bar = bg_texture.get_width()
	set_minigame_difficulty(.1, .4, Vector2(height_of_bar, width_of_bar))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Sets up the difficulty of the perfect and mid strike bars through percentages.
## Also should hopefully spawn the green percent within an acceptable range.
## Also this function isn't pure, it also sets up the minigame. (Im lazy)
func set_minigame_difficulty(green_percent: float, orange_percent: float = 1, bar_dimensions: Vector2 = Vector2(0.,0.)):
	# Background, place it in the center.
	$BackgroundContainer.position = Vector2(0,0) 
	# Green bar. Set the % to what we passed in.
	var perf_hit_sprite: Sprite2D = %PerfectHit
	perf_hit_sprite.scale.x = green_percent
	$PerfectHitContainer.position = Vector2(0,0) # Center the green rect on our container.
	
	# Left Orange bar.
	var medium_left_sprite: Sprite2D = %MediumHitLeft
	medium_left_sprite.scale.x = orange_percent / 2.0 # Half b/c the passed percent is the whole %
	
	# Right Orange bar
	var medium_right_sprite: Sprite2D = %MediumHitRight
	medium_right_sprite.scale.x = orange_percent / 2.0 # Half b/c the passed percent is the whole %
	
