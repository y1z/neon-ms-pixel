class_name ExMath extends Node


static func clamp_vec2(value: Vector2, min_value: Vector2, max_value: Vector2) -> Vector2:
	value.x = clampf(value.x, min_value.x, max_value.x)
	value.y = clampf(value.y, min_value.y, max_value.y)
	return value
