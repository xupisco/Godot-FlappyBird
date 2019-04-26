extends Node2D

var playing: bool = false
var pipes = preload("res://props/Pipes.tscn")
var score_num = preload("res://props/ScoreNum.tscn")
var score_textures: Array = []
var score: int = 0
var scores: Array = []

func _ready():
    randomize()
    $GUI.hide()
    $bgs.frame = randi() % 2
    
    for i in range(10):
        var tex = load("res://sprites/number_large_" + str(i) + ".png")
        score_textures.push_back(tex)
    

func _process(delta):
    pass


func build_score(): # Must have a better way to do this
    for n in $GUI/hbox.get_children():
        n.queue_free()

    var score_text = str(score)
    for s in score_text.length():
        var t = TextureRect
        var c = score_num.instance()
        c.update_value(score_textures[int(score_text.substr(s, 1))])
        $GUI/hbox.add_child(c)
    

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

