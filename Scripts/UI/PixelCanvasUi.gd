extends Control

const DEFAULT_TEXTURE_SIZE: Vector2i = Vector2i(64, 64)

var pixel_canvas: PixelCanvas
var state: Enums.GameState
var state_man : StateManager


func _ready() -> void:
	pixel_canvas = %canvas
	pixel_canvas.startup(GlobalsConstants.DEFAULT_SIZE)
	pixel_canvas.gui_input.connect(cb_gui_input)
	state_man = SystemsLocator.get_state_manager() 
	state = state_man.get_current_state()
	state_man.state_change.connect(cb_state_change)
	pass # Replace with function body.


func cb_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	if event is InputEventGesture:
		print(event)
	return

func cb_state_change(new_state:Enums.GameState) -> void:
	state = new_state

#region HANDLE 
func handle_mouse_motion(mouse_event: InputEventMouseMotion) -> void:
	print(mouse_event.screen_relative)
	return


func handle_mouse_button(mouse_event: InputEventMouseButton) -> void:
	if mouse_event.is_action_pressed("L_CLICK"):
		state_man.state_change.emit(Enums.GameState.left_press)
		pixel_canvas.color_pixel(mouse_event.position.x, mouse_event.position.y, PlayerData.pen_color)
	if mouse_event.is_action_released("L_CLICK"):
		state_man.state_change.emit(Enums.GameState.left_press_release)
	return
#endregion
