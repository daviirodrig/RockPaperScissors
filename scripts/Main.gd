extends Node2D

var win_scene = preload("res://scenes/Win.tscn")
var won = false

func _ready():
	spawn_all_mobs()

func _process(delta):
	check_winner()

func check_winner():
	if won: return
	var mobs = get_tree().get_nodes_in_group("mobs")
	var types = []
	for mob in mobs:
		types.append(mob.type)
	if is_every_element_same(types):
		var win = win_scene.instance()
		var winner_name = Globals.mob_types.keys()[types[0]].to_upper()
		win.get_node("Winner").text = "%s WINS" % winner_name
		add_child_below_node($ColorRect, win)
		won = true

func is_every_element_same(lst) -> bool:
	if not lst:  # empty list
		return false

	var first_element = lst[0]
	for element in lst:
		if element != first_element:
			return false

	return true


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


func _on_Audio_finished(audio):
	audio.queue_free()
