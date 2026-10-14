class_name CameraWithUI extends Camera2D

const MAX_ZOOM: Vector2 = Vector2(1000, 1000)
const MIN_ZOOM: Vector2 = Vector2(0.10, 0.10)
const INCREMENT_ZOOM_AMOUNT: Vector2 = Vector2(0.1, 0.1)

var state: Enums.GameState
var state_man: StateManager
var color_picker: ColorPickerButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_man = SystemsLocator.get_state_manager()
	state = state_man.get_current_state()
	state_man.state_change.connect(cb_state_change)
	color_picker = %ColorPickerButton
	color_picker.color_changed.connect(cb_color_changed)
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MOVEMENT"):
		state_man.state_change.emit(Enums.GameState.movement)
	if event.is_action_released("MOVEMENT"):
		state_man.state_change.emit(Enums.GameState.idle)
	if event.is_action_pressed("DEBUG_P"):
		print("zoom = %s" % self.zoom)

	if event is InputEventMouse:
		handle_mouse_wheel_input(event)
	if event is InputEventMouseMotion:
		handle_mouse_movement(event)
	if event is InputEventPanGesture:
		handle_pan_gesture_input(event)
	return


#region HANDLE functions
func handle_mouse_wheel_input(event: InputEventMouse) -> void:
	if event.is_action_pressed("UP_WHEEL"):
		self.zoom = ExMath.clamp_vec2(self.zoom + INCREMENT_ZOOM_AMOUNT, MIN_ZOOM, MAX_ZOOM)
	if event.is_action_pressed("DOWN_WHEEL"):
		self.zoom = ExMath.clamp_vec2(self.zoom + (INCREMENT_ZOOM_AMOUNT * -1), MIN_ZOOM, MAX_ZOOM)
	return


func handle_mouse_movement(event: InputEventMouseMotion) -> void:
	if state != Enums.GameState.movement: return
	var inverse_zoom_vector: Vector2 = Vector2(1.0 / zoom.x, 1.0 / zoom.y)
	var sr: Vector2 = event.screen_relative
	var how_much_to_move: Vector2 = Vector2(inverse_zoom_vector.x * sr.x, inverse_zoom_vector.y * sr.y)
	self.offset += how_much_to_move


## TODO: implement this for mobile version
func handle_pan_gesture_input(event: InputEventPanGesture) -> void:
	var _delta := event.delta
	return
#endregion


func cb_state_change(new_state: Enums.GameState) -> void:
	state = new_state


func cb_color_changed(new_color: Color) -> void:
	PlayerData.pen_color = new_color
