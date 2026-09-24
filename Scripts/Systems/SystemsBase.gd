@abstract class_name SystemBase extends Node2D

enum SystemResults
{
	NO_ERROR = 1,
	GENERAL_ERROR = 0,
	COULD_NOT_GET_RESOURCES_ERROR = -1,
}

enum SystemTypes { GAME_MANAGER ,STATE_MANAGER}


@abstract func startup() -> SystemResults ;


@abstract func shutdown() -> SystemResults ;


@abstract func debug_string() -> String;


@abstract func debug_print() -> void;
