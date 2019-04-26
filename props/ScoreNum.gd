extends TextureRect

var current: int = 0
var textures: Array = []

func _ready():
    for i in range(10):
        var tex = load("res://sprites/number_large_" + str(i) + ".png")
        textures.push_back(tex)
    texture = textures[0]
    
func update_value():
    pass