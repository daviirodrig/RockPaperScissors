extends Control

var twitch = preload("res://scripts/Twitch.gd")

func _on_ConnectButton_pressed():
	if get_node("/root/Twitch") != null: return
	var channel_input = $CenterContainer/HBoxContainer/ChannelText
	var t = twitch.new()
	t.name = "Twitch"
	t.channel = channel_input.text
	get_node('/root/').add_child(t)
