extends Node


func _on_Bolt_timeout(mob, timer):
	if is_instance_valid(mob):
		mob.speed = 10
	timer.queue_free()

func _on_Audio_finished(audio):
	audio.queue_free()
