extends Node2D

func _ready():
	$Winner/AnimationPlayer.play("New Anim")


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_MenuButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
