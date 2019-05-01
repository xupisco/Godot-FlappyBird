extends Node2D

var playing: bool = false
var dead: bool = false
var paused: bool = false
var pipes = preload("res://props/Pipes.tscn")
var score_num = preload("res://props/ScoreNum.tscn")
var final_score_num = preload("res://props/end_score_num.tscn")
var score_textures: Array = []
var score: int = 0
var score_value = 1
var scores: Array = []

func _ready():
    randomize()
    $GUI.hide()
    $GameOver.hide()
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
    draw_final_scores()
    $GameOver.show()
    

func draw_final_scores():
    for n in $GameOver/final_score.get_children():
        n.queue_free()
    var score_text = str(score)
    var start_pos = 0
    for s in score_text.length():
        var fc = final_score_num.instance()
        fc.frame = int(score_text.substr(s, 1))
        if s > 0 and int(score_text.substr(s - 1, 1)) == 1:
            start_pos -= 2
        fc.position.x += 8 * s + start_pos
        $GameOver/final_score.add_child(fc)
    $GameOver/final_score.position.x -= start_pos + 8 * (score_text.length() - 1)
        

func _on_add_score():
    score += score_value
    build_score()
    $sfx_score.play()


func _input(event):
    if event.is_action_pressed("flap") and not playing and not dead:
        begin_game()
    if event.is_action_pressed("restart"):
        get_tree().reload_current_scene()


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
    if body.name == "bottom" or body.name == "Ground":
        if $Bird.mode != RigidBody2D.MODE_KINEMATIC:
            $Bird.mode = RigidBody2D.MODE_KINEMATIC
    if body.name != "trigger" and not dead:
        died()
