extends StaticBody2D

export(bool) var moving = false;
var game_started:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not moving:
		$anin.stop()


func _process(delta):
	if moving and not game_started:
		$anin.play("moving")
		game_started = true
