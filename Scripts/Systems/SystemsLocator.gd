extends Node

var has_already_started: bool = false
var state_manager: StateManager


func startup() -> void:
	if has_already_started:
		printerr("Trying to start up SERVICE LOCATOR MULTIPLE TIMES")
		return
	state_manager = StateManager.new()
	state_manager.startup()
	has_already_started = true
	return ;


func shutdown() -> void:
	if not has_already_started:
		printerr("Trying to shutdown ALREADY shutdown SERVICE LOCATOR ")
		return
	has_already_started = false;
	state_manager.shutdown()
	state_manager = null


func get_state_manager() -> StateManager:
	if !has_already_started:
		printerr("have not started up service locator DO THAT FIRST")
		return null
	return state_manager
