extends KinematicBody2D

var is_player_controlling = false
var speed = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(self.name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction
	randomize()
	if !is_player_controlling:
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
	var shader
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		if is_player_controlling:
			is_player_controlling = false
			shader = load("res://shaders/outline.shader")
		else:
			is_player_controlling = true
			shader = load("res://shaders/glow.shader")
		var sprite = get_node("Area2D/Sprite")
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = shader
