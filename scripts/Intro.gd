extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_btn_play_released():
    get_tree().change_scene("./scenes/Game.tscn")
