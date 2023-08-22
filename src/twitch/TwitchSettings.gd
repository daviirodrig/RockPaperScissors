extends Control

var twitch = preload("res://src/twitch/Twitch.gd")
var GameScene := preload("res://src/main/Main.tscn")
var MobScene := preload("res://src/mob/Mob.tscn")
var n_users := 0
var users := []

func _on_ConnectButton_pressed():
	if get_node_or_null("/root/Twitch") != null:
		return
	var channel_input: String = %ChannelText.text
	if channel_input.strip_edges() == "":
		return
	var t = twitch.new()
	t.chat_message.connect(on_message)
	t.channel_connected.connect(on_channel_connected)
	t.name = "Twitch"
	t.channel = channel_input
	get_node("/root/").add_child(t)

func _on_BackButton_pressed():
	get_node('/root/').remove_child(get_node_or_null("/root/Twitch"))
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")

func on_message(msg: String):
	var message = msg.split(":")[-1]
	#if !message.begins_with("!play"): return
	var user = msg.split(":")[1].split("!")[0]
	if user in users: return
	users.append(user)
	n_users = len(users)
	%Users.text = str(n_users) + " players"

func on_channel_connected(ch: String):
	%Status.text = "Connected to {ch}".format({"ch": ch})
	%Status.modulate = Color.GREEN


func _on_start_button_pressed() -> void:
	var game = GameScene.instantiate()
	game.is_twitch = true
	for u in users:
		var mob = MobScene.instantiate()
		mob.name = u
		mob.type = Globals.mob_types.values().pick_random()
		var screen_size = get_viewport().get_visible_rect().size
		var pos_w = randi() % int(screen_size.x-20)
		var pos_h = randi() % int(screen_size.y-20)
		mob.position = Vector2(pos_w, pos_h)
		game.add_child(mob)
	get_node('/root/').remove_child(get_node_or_null("/root/Twitch"))
	self.visible = false
	get_node("/root/").add_child(game)

