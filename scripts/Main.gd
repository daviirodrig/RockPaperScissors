extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_all_mobs()


func spawn_all_mobs():
	var scenes = ["res://scenes/Rock.tscn", "res://scenes/Paper.tscn", "res://scenes/Scissors.tscn"]

	for scene_path in scenes:
		for _x in range(15):
			randomize()
			var pos_w = randi() % int(get_viewport().size.x)
			var pos_h = randi() % int(get_viewport().size.y)
			spawn_one_mob(scene_path, pos_w, pos_h)


func spawn_one_mob(scene_path, pos_w, pos_h):
	var scene = load(scene_path)
	scene = scene.instance()

	scene.position = Vector2(pos_w, pos_h)

	add_child(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
