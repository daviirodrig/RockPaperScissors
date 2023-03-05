extends Area2D


func _on_Bolt_body_entered(body):
	if !("Mob" in body.name): return

	self.queue_free()
	body.speed = 25
	var sprite = body.get_node("Area2D/Sprite2D")
	sprite.material = ShaderMaterial.new()
	sprite.material.gdshader = load("res://assets/shaders/rainbow.gdshader")
	sprite.material.set_shader_parameter("speed", 3)

	var timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout",Callable(get_node("/root/SignalManager"),"_on_Bolt_timeout").bind(body, timer))

	get_node("/root/Main").add_child(timer)
