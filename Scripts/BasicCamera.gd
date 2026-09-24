class_name BasicCamera extends Camera2D

var state: Enums.GameState


func _ready() -> void:
	var state_man := SystemsLocator.get_state_manager()
	state = state_man.get_current_state()
	state_man.state_change.connect(cb_state_change)
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
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
		self.zoom += Vector2(0.1, 0.1)
	if event.is_action_pressed("DOWN_WHEEL"):
		self.zoom += Vector2(0.1, 0.1) * (-1)
	return


func handle_mouse_movement(event: InputEventMouseMotion) -> void:
	return


## TODO: implement this 
func handle_pan_gesture_input(event: InputEventPanGesture) -> void:
	var _delta := event.delta
	return
#endregion


func cb_state_change(new_state: Enums.GameState) -> void:
	state = new_state
