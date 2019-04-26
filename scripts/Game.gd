extends Node2D

signal score_changed

var playing: bool = false
var pipes = preload("res://props/Pipes.tscn")
var score: int = 0

func _ready():
    randomize()
    $GUI.hide()
    $bgs.frame = randi() % 2


func _process(delta):
    pass


func build_score():
    emit_signal("score_changed")


func begin_game():
    $Bird.flying = true
    $Ground.moving = true
    $info.hide()
    build_score()
    $GUI.show()
    playing = true
    $pipe_spawner.start()


func _on_add_score():
    score += 1
    build_score()
    $sfx_score.play()


func _input(event):
    if event.is_action_pressed("flap") and not playing:
        begin_game()


func _on_pipe_spawner_timeout():
    var np = pipes.instance()
    np.position.y = rand_range(70, 140)
    np.connect("add_score", self, "_on_add_score")
    $PipeContainer.add_child(np)

