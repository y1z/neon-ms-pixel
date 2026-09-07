extends Control

const DEFAULT_TEXTURE_SIZE: Vector2i = Vector2i(64, 64)

var canvas_rect: TextureRect
var canvas_image: ImageTexture


static func create_blank_texture(size_: Vector2i) -> ImageTexture:
	var image: Image = Image.create_empty(size_.x, size_.y, false, Image.FORMAT_RGBA8)

	return ImageTexture.create_from_image(image)

#

#


func _ready() -> void:
	canvas_rect = %canvas
	canvas_image = create_blank_texture(DEFAULT_TEXTURE_SIZE)
	canvas_rect.texture = canvas_image
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
