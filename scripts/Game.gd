extends Node2D


var playing: bool = false;

func _ready():
    pass


func _process(delta):
    pass


func begin_game():
    $Bird.flying = true
    $Ground.moving = true
    $info.hide()
    playing = true


func _input(event):
    if event.is_action_pressed("flap"):
        begin_game()
