extends Control

var twitch = preload("res://src/twitch/Twitch.gd")


func _on_ConnectButton_pressed():
	if get_node_or_null("/root/Twitch") != null:
		return
	var channel_input = %ChannelText
	if channel_input.text == "":
		return
	var t = twitch.new()
	t.name = "Twitch"
	t.channel = channel_input.text
	get_node("/root/").add_child(t)

func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://src/menu/Menu.tscn")
