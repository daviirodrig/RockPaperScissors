extends Control

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://src/main/Main.tscn")


func _on_TwitchButton_pressed():
	get_tree().change_scene_to_file("res://src/twitch/TwitchSettings.tscn")
