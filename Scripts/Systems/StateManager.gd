class_name StateManager extends SystemBase

var current_state: Enums.GameState = Enums.GameState.idle

func startup() ->SystemBase.SystemResults :
	return  SystemResults.no_error


func shutdown() -> SystemResults :
	return SystemResults.no_error


func debug_string() -> String:
	return "State manager"


func debug_print() -> void:
	print(debug_string())
