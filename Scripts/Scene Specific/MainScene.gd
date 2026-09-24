extends Node

var camera : CameraWithUI = null
var camera_preload := preload("uid://ccxgo2ke54yal")
var state : Enums.GameState = Enums.GameState.idle
var state_man : StateManager = null

func _enter_tree() -> void:
	SystemsLocator.startup()

func _ready() -> void:
	state_man = SystemsLocator.get_state_manager()
	state_man.state_change.connect(cb_state_change)
	
	camera = CameraWithUI.new()
	if camera_preload.can_instantiate():
		camera = camera_preload.instantiate()
	add_child(camera)
	pass # Replace with function body.

func _exit_tree() -> void:
	SystemsLocator.shutdown()

func cb_state_change(new_state:Enums.GameState) -> void:
	state = new_state
