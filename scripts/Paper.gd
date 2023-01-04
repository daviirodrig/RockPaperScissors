extends KinematicBody2D

var speed = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(self.name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction
	randomize()
	if PlayerVariables.controlling_node != self:
		var rand_x = rand_range(-5, 5)
		var rand_y = rand_range(-5, 5)
		direction = Vector2(rand_x, rand_y)
	else:
		direction = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1

		if direction.length() > 0:
			direction = direction.normalized() * speed
	var collision = move_and_collide(direction)
	if collision:
		check_collide(collision.collider)


func check_collide(area):
	if "Rock" in area.name:
		print("[ELIM] {Rock} -> " + str(self.name))
		$PaperSound.play(0)
		area.queue_free()
	if "Scissors" in area.name:
		print("[ELIM] Scissors -> " + str(self.name))
		$ScissorSound.play()
		self.queue_free()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	var outline_shader = load("res://shaders/outline.shader")
	var glow_shader = load("res://shaders/glow.shader")
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		if PlayerVariables.controlling_node == self:
			load_shader_on_node(self, outline_shader)
			PlayerVariables.controlling_node = null

		elif PlayerVariables.controlling_node == null:
			load_shader_on_node(self, glow_shader)
			PlayerVariables.controlling_node = self

		else:
			load_shader_on_node(PlayerVariables.controlling_node, outline_shader)
			load_shader_on_node(self, glow_shader)
			PlayerVariables.controlling_node = self


func load_shader_on_node(node: Node, shader: Shader):
	if node == null:
		return
	var sprite = node.get_node("Area2D/Sprite")
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = shader
