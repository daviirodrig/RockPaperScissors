extends Control


func _ready():
	$CenterContainer/Subtitle/AnimationPlayer.play("New Anim")

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")



func _on_TwitchButton_pressed():
	get_tree().change_scene_to_file("res://scenes/TwitchSettings.tscn")
