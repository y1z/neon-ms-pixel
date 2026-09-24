@abstract class_name SystemBase extends Node2D

enum SystemResults
{
	no_error = 1,
	general_error = 0,
	could_not_get_resources_error = -1,
}

enum SystemTypes { game_manager ,state_manager}


@abstract func startup() -> SystemResults ;


@abstract func shutdown() -> SystemResults ;


@abstract func debug_string() -> String;


@abstract func debug_print() -> void;
