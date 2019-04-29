extends Node2D

var playing: bool = false
var dead: bool = false
var paused: bool = false
var pipes = preload("res://props/Pipes.tscn")
var score_num = preload("res://props/ScoreNum.tscn")
var score_textures: Array = []
var score: int = 0
var scores: Array = []

func _ready():
    randomize()
    $GUI.hide()
    $bgs.frame = randi() % 2
    $btn_pause.hide()
    
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
    $btn_pause.show()
    $idle_anim.queue_free()
    $Bird.flying = true
    $Ground.moving = true
    $info.hide()
    build_score()
    $GUI.show()
    playing = true
    $pipe_spawner.start()

func died():
    if dead:
        return
    $sfx_die.play()
    $Bird.dead = true
    $pipe_spawner.stop()
    $Ground.get_node("anin").stop()
    for p in $PipeContainer.get_children():
        p.get_node("anim").stop()
    playing = false
    dead = true

func _on_add_score():
    score += 1
    build_score()
    $sfx_score.play()


func _input(event):
    if event.is_action_pressed("flap") and not playing and not dead:
        begin_game()


func _on_pipe_spawner_timeout():
    var np = pipes.instance()
    np.position.y = rand_range(70, 140)
    np.connect("add_score", self, "_on_add_score")
    $PipeContainer.add_child(np)


func _on_btn_pause_released():
    if not paused:
        $btn_pause.normal = load("res://sprites/button_resume.png")
    else:
        $btn_pause.normal = load("res://sprites/button_pause.png")
    paused = !paused
    get_tree().paused = paused


func _on_Bird_body_entered(body):
    if body.name != "trigger" and not dead:
        died()
