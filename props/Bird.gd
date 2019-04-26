extends RigidBody2D

export(bool) var flying = false
export(Vector2) var flap_force = Vector2()
var game_started:bool = false


func _ready():
    randomize()
    $spr.play("fly_" + str(randi() % 2))
    if not flying:
        $spr.playing = false
        mode = MODE_KINEMATIC


func _process(delta):
    if flying and not game_started:
        mode = MODE_CHARACTER
        fly()
        game_started = true
 

func _physics_process(delta):
    if rotation_degrees < -30:
        rotation_degrees = -30
        angular_velocity = 0

    if linear_velocity.y > 0:
        angular_velocity = 2


func fly():
    $spr.frame = 1
    $spr.playing = true
    $sfx_flap.play()
    linear_velocity = Vector2.ZERO
    apply_impulse(Vector2.UP, flap_force)
    angular_velocity = -3


func _input(event):
    if event.is_action_pressed("flap"):
        fly() 


func _on_spr_animation_finished():
    $spr.playing = false;
