extends Control

var twitch = preload("res://src/twitch/Twitch.gd")
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
