extends Node

var camera : BasicCamera = null
var state : Enums.GameState = Enums.GameState.idle
func _ready() -> void:
	camera = BasicCamera.new()
	add_child(camera)
	pass # Replace with function body.
