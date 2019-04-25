extends RigidBody2D

export(bool) var flying = false
export(Vector2) var flap_force = Vector2()
var game_started:bool = false


func _ready():
    if not flying:
        $spr.playing = false;
        mode = MODE_KINEMATIC


func _process(delta):
    if flying and not game_started:
        mode = MODE_CHARACTER
        fly()
        game_started = true


func fly():
    $spr.frame = 1
    $spr.playing = true
    linear_velocity = Vector2.ZERO
    apply_impulse(Vector2.UP, flap_force)


func _input(event):
    if event.is_action_pressed("flap"):
        fly() 


func _physics_process(delta):
    pass

func _on_spr_animation_finished():
    $spr.playing = false;
