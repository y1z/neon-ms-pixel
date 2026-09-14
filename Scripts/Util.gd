class_name Util extends Node

#Util


static func create_blank_texture(size_: Vector2i) -> ImageTexture:
	var image: Image = Image.create_empty(size_.x, size_.y, false, GlobalsConstants.DEFAULT_IMAGE_FORMAT)

	return ImageTexture.create_from_image(image)


static func create_filled_color_texture(_size: Vector2i, _color: Color) -> ImageTexture:
	var image: Image = Image.create_empty(_size.x, _size.y, false, GlobalsConstants.DEFAULT_IMAGE_FORMAT)
	image.fill(_color)
	return ImageTexture.create_from_image(image)


static func create_blank_image(size_: Vector2i) -> Image:
	return Image.create_empty(size_.x, size_.y, false, GlobalsConstants.DEFAULT_IMAGE_FORMAT)
