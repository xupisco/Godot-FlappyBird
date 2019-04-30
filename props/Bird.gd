extends RigidBody2D

export(bool) var flying = false
export(Vector2) var flap_force = Vector2()
var game_started:bool = false
var dead:bool = false


func _ready():
    randomize()
    $spr.play("fly_" + str(randi() % 2))
    if not flying:
        mode = MODE_KINEMATIC


func _process(delta):
    if flying and not game_started:
        mode = MODE_CHARACTER
        fly()
        game_started = true
 

func _physics_process(delta):
    if rotation_degrees < -25:
        rotation_degrees = -25
        angular_velocity = 0

    if linear_velocity.y > 0:
        angular_velocity = 2.5
    
    if dead and linear_velocity.y <= 0:
        rotation_degrees = 90


func fly():
    if dead or not flying:
        return
    $spr.frame = 1
    $spr.playing = true
    $sfx_flap.play()
    linear_velocity = Vector2.ZERO
    rotation_degrees = 0
    linear_velocity.y = flap_force.y
    #apply_impulse(Vector2.UP, flap_force)
    angular_velocity = -4


func _input(event):
    if event.is_action_pressed("flap") and not dead:
        fly() 


func _on_spr_animation_finished():
    if game_started:
        $spr.playing = false;
