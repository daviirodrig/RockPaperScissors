extends Node2D


func _ready():
	spawn_all_mobs()


func spawn_all_mobs():
	for type in Globals.mob_types.values():
		for _x in range(10):
			randomize()
			var size = get_viewport().get_visible_rect().size
			var pos_w = randi() % int(size.x)
			var pos_h = randi() % int(size.y)
			spawn_one_mob(type, pos_w, pos_h)


func spawn_one_mob(type, pos_w, pos_h):
	var scene = load("res://scenes/Mob.tscn")
	var mob = scene.instance()

	mob.type = type
	mob.position = Vector2(pos_w, pos_h)

	add_child(mob)
