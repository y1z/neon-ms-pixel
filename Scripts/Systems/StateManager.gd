class_name StateManager extends SystemBase

var current_state: Enums.GameState = Enums.GameState.idle

func startup() -> SystemResults :
	return SystemResults.NO_ERROR


func shutdown() -> SystemResults :
	return SystemResults.NO_ERROR


func debug_string() -> String:
	return "State manager"


func debug_print() -> void:
	print(debug_string())
