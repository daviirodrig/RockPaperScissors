extends Node2D

var win_scene = preload("res://src/main/win/Win.tscn")
var bolt_scene = preload("res://src/powerups/bolt/Bolt.tscn")
var ice_scene = preload("res://src/powerups/ice/Ice.tscn")
var won = false
var is_twitch = false


func _ready():
	if not is_twitch:
		spawn_all_mobs()
	spawn_powerup(bolt_scene)
	spawn_powerup(ice_scene)


func _process(_delta):
	check_winner()


func check_winner():
	if won:
		return
	var mobs = get_tree().get_nodes_in_group("mobs")
	var types = []
	for mob in mobs:
		types.append(mob.type)
	if is_every_element_same(types):
		var win = win_scene.instantiate()
		var winner_name = Globals.mob_types.keys()[types[0]].to_upper()
		win.get_node("Winner").text = "%s WINS" % winner_name
		$ColorRect.add_sibling(win)
		won = true


func is_every_element_same(lst: Array) -> bool:
	if lst.is_empty():
		return false

	var first_element = lst[0]
	for element in lst:
		if element != first_element:
			return false

	return true


func spawn_all_mobs():
	for type in Globals.mob_types.values():
		for _x in range(800):
			randomize()
			var size = Vector2(-10000, -10000) # get_viewport().get_visible_rect().size
			var pos_w = randi_range(-9000, 10000)#randi() % int(size.x)
			var pos_h = randi_range(-9000, 10000)#randi() % int(size.y)
			spawn_one_mob(type, pos_w, pos_h)


func spawn_one_mob(type, pos_w, pos_h):
	var scene = load("res://src/mob/Mob.tscn")
	var mob = scene.instantiate()

	mob.type = type
	mob.position = Vector2(pos_w, pos_h)

	add_child(mob)


func spawn_powerup(powerup_scene: PackedScene):
	randomize()
	var powerup: Area2D = powerup_scene.instantiate()
	var viewport_size = get_viewport().get_visible_rect().size
	var location = Vector2(randi() % int(viewport_size.x), randi() % int(viewport_size.y))
	powerup.position = location
	add_child(powerup)
