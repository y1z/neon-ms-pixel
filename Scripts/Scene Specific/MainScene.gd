extends Node

var camera : BasicCamera = null

func _ready() -> void:
	camera = BasicCamera.new()
	add_child(camera)
	pass # Replace with function body.
