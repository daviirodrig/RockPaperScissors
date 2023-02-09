extends Area2D


func _on_Bolt_body_entered(body):
	if !("Mob" in body.name): return

	self.queue_free()
	body.speed = 25
	var sprite = body.get_node("Area2D/Sprite")
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://assets/shaders/rainbow.shader")
	sprite.material.set_shader_param("speed", 3)

	var timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", get_node("/root/SignalManager"), "_on_Bolt_timeout", [body, timer])

	get_node("/root/Main").add_child(timer)
