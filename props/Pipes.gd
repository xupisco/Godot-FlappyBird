extends Node2D

signal add_score

func _ready():
    pass

func _on_trigger_body_entered(body):
    if body.name == "Bird":
        emit_signal("add_score")


func _on_anim_animation_finished(anim_name):
    queue_free()
