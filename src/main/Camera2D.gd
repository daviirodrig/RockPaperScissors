extends Camera2D

var _target_zoom := 1.0
const MIN_ZOOM := 0.1
const MAX_ZOOM := 1.5
const ZOOM_INCREMENT := 0.1
const ZOOM_RATE := 8.0
var _focus_tween = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			self.position -= event.relative / self.zoom
	if (event is InputEventMouseButton) and (event.is_pressed()):
		if event.double_click:
			print(get_global_mouse_position())
			focus_position(get_global_mouse_position())
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			
			_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
			set_physics_process(true)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			
			_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
			set_physics_process(true)
			


func _physics_process(delta: float) -> void:
	self.zoom = lerp(self.zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))

func focus_position(target_position: Vector2) -> void:
	_focus_tween = create_tween()
	_focus_tween.set_trans(Tween.TRANS_EXPO)
	_focus_tween.tween_property(self, "position", target_position, 0.2)
