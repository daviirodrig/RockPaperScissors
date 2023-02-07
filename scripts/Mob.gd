extends KinematicBody2D
class_name Mob

var type: int
var speed = 10


func _ready():
	set_sprite()


func set_sprite():
	var sprite = get_node("Area2D/Sprite")
	var keys = Globals.mob_types.keys()
	var texture = load("res://assets/sprites/%s.png" % keys[type].to_lower())
	sprite.texture = texture


func check_inputs():
	var direction
	if Globals.controlling_node == self:
		direction = Vector2(
			int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
			int(Input.is_action_pressed("move_down"))  - int(Input.is_action_pressed("move_up"))
		).normalized()
	else:
		randomize()
		var rand_x = rand_range(-1, 1)
		var rand_y = rand_range(-1, 1)
		direction = Vector2(rand_x, rand_y)
	var collision = move_and_collide(direction * speed)
	if collision:
		if "Bolt" in collision.collider.name:
			collided_with_bolt(collision.collider)
		check_collide(collision.collider)


func collided_with_bolt(bolt):
	bolt.free()
	self.speed = 15
	var timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.connect("timeout", get_node("/root/Main"), "_on_Bolt_timeout", [self, timer])
	timer.autostart = true
	get_node("/root/Main").add_child(timer)

func check_collide(collider: Mob):
	if collider == null:
		return
	if self.type == Globals.mob_types.SCISSORS:
		if collider.type == Globals.mob_types.PAPER:
			print("[ELIM] {Paper} -> " + str(self.name))
			play_sound("scissors")
			collider.queue_free()

		if collider.type == Globals.mob_types.ROCK:
			print("[ELIM] Rock -> " + str(self.name))
			play_sound("rock")
			self.queue_free()

	elif self.type == Globals.mob_types.PAPER:
		if collider.type == Globals.mob_types.ROCK:
			print("[ELIM] {Rock} -> " + str(self.name))
			play_sound("paper")
			collider.queue_free()

		if collider.type == Globals.mob_types.SCISSORS:
			print("[ELIM] Scissors -> " + str(self.name))
			play_sound("scissors")
			self.queue_free()

	elif self.type == Globals.mob_types.ROCK:
		if collider.type == Globals.mob_types.PAPER:
			print("[ELIM] Paper -> " + str(self.name))
			play_sound("paper")
			self.queue_free()

		if collider.type == Globals.mob_types.SCISSORS:
			print("[ELIM] {Scissors} -> " + str(self.name))
			play_sound("rock")
			collider.queue_free()


func play_sound(name: String):
	var hit_audio = AudioStreamPlayer.new()
	hit_audio.connect("finished", get_node("/root/Main"), "_on_Audio_finished", [hit_audio])
	var stream = load("res://assets/sfx/%s.mp3" % name.to_lower())
	hit_audio.stream = stream
	get_node("/root/Main").add_child(hit_audio)
	hit_audio.play()


func _physics_process(_delta):
	check_inputs()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	var outline_shader = load("res://assets/shaders/outline.shader")
	var glow_shader = load("res://assets/shaders/glow.shader")
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		if Globals.controlling_node == self:
			load_shader_on_node(self, outline_shader)
			Globals.controlling_node = null

		elif Globals.controlling_node == null:
			load_shader_on_node(self, glow_shader)
			Globals.controlling_node = self

		else:
			load_shader_on_node(Globals.controlling_node, outline_shader)
			load_shader_on_node(self, glow_shader)
			Globals.controlling_node = self


func load_shader_on_node(node: Node, shader: Shader):
	if node == null:
		return
	var sprite = node.get_node("Area2D/Sprite")
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = shader
