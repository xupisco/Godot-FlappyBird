extends Node2D


func _ready():
    pass # Replace with function body.

#func _process(delta):
#    pass

func _on_btn_ok_released():
    get_tree().reload_current_scene()
