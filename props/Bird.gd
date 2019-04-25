extends RigidBody2D

export(bool) var flying = false
var game_started:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not flying:
		$spr.playing = false;
		mode = MODE_KINEMATIC


func _process(delta):
	if flying and not game_started:
		$spr.playing = true
		mode = MODE_CHARACTER
		game_started = true

