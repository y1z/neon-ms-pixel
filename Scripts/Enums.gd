class_name Enums extends Node

enum GameState ## Game state control how the individual component react.
{ 
	idle, ## idle nothing happens
	left_press, ## the left mouse button is pressed (to be determiend later how this will affect cell phone version
	left_press_release, ## the left press is released
	movement, ## we trying to move
}
