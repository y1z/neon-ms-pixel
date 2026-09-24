class_name StateManager extends SystemBase

var __current_state: Enums.GameState = Enums.GameState.idle:
	set(new_state):
		__current_state = new_state
		state_change.emit(new_state)

signal state_change(new_game_state:Enums.GameState) ;

func startup() -> SystemBase.SystemResults:
	return SystemResults.no_error


func shutdown() -> SystemResults:
	return SystemResults.no_error

func debug_string() -> String:
	return "State manager\n" + ("current state %s\n" % __current_state) 


func debug_print() -> void:
	print(debug_string())
