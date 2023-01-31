extends Control


func _ready():
	$Subtitle/AnimationPlayer.play("New Anim")

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

