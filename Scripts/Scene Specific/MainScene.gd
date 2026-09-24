extends Node

var camera : BasicCamera = null
var state : Enums.GameState = Enums.GameState.idle
var state_man : StateManager = null

func _enter_tree() -> void:
	SystemsLocator.startup()

func _ready() -> void:
	state_man = SystemsLocator.get_state_manager()
	state_man.state_change.connect(cb_state_change)
	
	camera = BasicCamera.new()
	add_child(camera)
	pass # Replace with function body.

func _exit_tree() -> void:
	SystemsLocator.shutdown()

func cb_state_change(new_state:Enums.GameState) -> void:
	state = new_state
