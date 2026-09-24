class_name PixelCanvas extends TextureRect

var pixel_image: Image


func _ready() -> void:
	pixel_image = Util.create_blank_image(GlobalsConstants.DEFAULT_SIZE)
	self.texture = ImageTexture.create_from_image(pixel_image)
	pass # Replace with function body.


func startup(size_: Vector2i,color:Color = GlobalsConstants.DEFAULT_BLANK_COLOR) -> void:
	pixel_image = Image.create_empty(size_.x, size_.y, false, GlobalsConstants.DEFAULT_IMAGE_FORMAT)
	pixel_image.fill(color)
	self.texture = ImageTexture.create_from_image(pixel_image)
	return

func change_image_size(new_size_:Vector2i,interpolation: Image.Interpolation = GlobalsConstants.DEFAULT_INTERPOLATION) -> void:
	pixel_image.resize(new_size_.x,new_size_.y,interpolation)
	self.texture.update(pixel_image)


## @returns False if out of bounds other wise returns true
func color_pixel(x: int, y: int, color: Color) -> bool:
	var p_width := pixel_image.get_width()
	var p_height := pixel_image.get_height()
	if x < p_width  and y < p_height:
		pixel_image.set_pixel(x, y, color)
		self.texture.update(pixel_image)
		return true

	return false
