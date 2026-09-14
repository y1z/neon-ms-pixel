@tool
extends EditorScript
class_name ConfigureEntireProject

const proj_dirs := [
	"res://Entities",
	"res://Entities/UI",
	"res://Scenes",
	"res://Scenes/UI",
	"res://Scripts",
	"res://Scripts/Debug Only",
	"res://Scripts/Editor",
	"res://Scripts/UI",
	"res://Sprites",
	"res://Textures",
	"res://Themes",
]

const folder_colors := {
	"res://Entities/": "orange",
	"res://Scenes/": "red",
	"res://Scripts/": "green",
	"res://Sprites/": "yellow",
	"res://Textures/": "purple",
	"res://Themes/": "pink"
}

enum StretchModes
{
	disabled,
	canvas_items,
	viewport,
}

enum FilterModes
{
	Nearest,
	Linear,
	Linear_Mipmap,
	Nearest_Mipmap,

}

const window_title :String = "Configure entire project"
const window_size : Vector2i = Vector2i(545, 700)

var cb_default_function := Callable (default_button_function)

const default_ui_size:Vector2i = Vector2i(100,100)


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var window : Window = Window.new()
	window.title = window_title
	window.size = window_size
	window.close_requested.connect(
		func() -> void:
			window.queue_free()
	)
	add_ui_to_window(window)
	
	EditorInterface.popup_dialog_centered(window, window.size)

#region CREATE PROJECT FOLDERS
func generate_directories() -> bool:
	print("generating folders for project")
	var result: bool = false

	for d:String in proj_dirs:
		if not DirAccess.dir_exists_absolute(d):
			var err := DirAccess.make_dir_recursive_absolute(d)

			if err != OK:
				push_error("Failed to create: %s (error %d)" % [d, err])
				return result;
		else:
			print("Already created %s" % d)

	result = true
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[b]Finished generating folders for project [/b]")

	return result


func color_folders() -> void:
	print_rich("[i]Coloring folder for Project[/i]")
	ProjectSettings.set_setting("file_customization/folder_colors", folder_colors)
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[b]Finished coloring folder for Project [/b]")

	pass

func create_project_folders() ->void :
	if generate_directories():
		color_folders()
	pass
#endregion

#region ADD UI ELEMENTS
func add_button(name : String, size :Vector2i, call_back_function : Callable  = default_button_function ) -> Button:
	var result : Button = Button.new()
	result.text = name
	result.size = size
	callable_info_print(call_back_function)
	if call_back_function.is_null():
		call_back_function = func() -> void: print("pressed button")

	if call_back_function.get_argument_count() != 0:
		printerr("Can only use callables with zero arguments")
		assert(false)
	
	result.pressed.connect(
		func() -> void:
			call_back_function.call()
	)
	
	return result

func add_line_edit(size:Vector2i ,call_back :Callable = default_line_edit_function ) -> LineEdit:
	var result : LineEdit = LineEdit.new()
	result.size = size
	result.text_submitted.connect(
		func(input_text:String) -> void:
			call_back.call(input_text)
	)
	return result

func add_static_line_edit(size:Vector2i ,call_back :Callable = default_line_edit_function ) -> LineEdit:
	var result : LineEdit = LineEdit.new()
	result.size = size
	result.editable = false
	result.text_submitted.connect(
		func(input_text:String) -> void:
			call_back.call(input_text)
	)
	return result

func add_static_line_edit_with_text(size:Vector2i, text:String, call_back:Callable = default_line_edit_function) -> LineEdit:
	var result : LineEdit = add_static_line_edit(size,call_back)
	result.text = text
	result.alignment = HORIZONTAL_ALIGNMENT_CENTER
	return result

func add_hbox(elements: Array[Control]) -> HBoxContainer:
	var result : HBoxContainer = HBoxContainer.new()
	for e in elements:
		result.add_child(e)
	return result

func add_panel(size:Vector2i) -> Panel:
	var result : Panel = Panel.new() 
	result.size = size
	
	return result

func add_panel_container(size:Vector2i) -> PanelContainer:
	var result : PanelContainer = PanelContainer.new()
	result.size = size
	return result;

## THIS HAS TO BE STATIC OR we get the following error `ERROR: res://Scripts/configure_entire_project.gd:96 - Attempt to call function 'null::default_button_function (Callable)' on a null instance.`
static func default_button_function() -> void:
	print("Default Button pressed function")

static func default_line_edit_function(input_string : String) -> void:
	print("Current input text = %s" % input_string)

#endregion



func add_ui_to_window(window: Window) -> void :
	var vbox : VBoxContainer = VBoxContainer.new()
	var control : Control = Control.new()
	var scroll_container : ScrollContainer = ScrollContainer.new()
	# do this or the container is invisible.
	scroll_container.custom_minimum_size = window_size
	control.add_child(scroll_container)
	scroll_container.add_child(vbox)

	vbox.add_child(
		add_button("save and reset",
		Vector2i(100,100),
		func() -> void:
			ProjectSettings.save()
			EditorInterface.restart_editor(true)
			)
	)
	
	vbox.add_child(
		add_button("create folders",
		Vector2i(100,100),
		func() -> void:create_project_folders()
	))
	
	var line_edit_width := add_line_edit(default_ui_size,
	 func(input_text:String) -> void:
		change_viewport_size(true, input_text.to_int()
		) )
	var width_text_input :HBoxContainer = add_hbox([
		line_edit_width,
		add_button("confirm width",default_ui_size,
		 func() -> void:
			line_edit_width.text_submitted.emit(line_edit_width.text)),
		 ])

	

	var line_edit_height := add_line_edit(default_ui_size, 
	func(input_text:String) -> void:
		change_viewport_size(false, input_text.to_int()) 
		)

	var height_text_input :HBoxContainer = add_hbox([
		line_edit_height,
		add_button("confirm height",default_ui_size, 
		func() -> void:
			line_edit_height.text_submitted.emit(line_edit_height.text)),
		 ])

	vbox.add_child(width_text_input)
	vbox.add_child(height_text_input)
	
	var shadow_warning_container : HBoxContainer = add_hbox(
		[add_button("Set 'shadowed' warnings to ERROR",
		Vector2i(100,00),
		func() ->void:change_shadowed_warnings(true)
		),
		add_button("Set 'shadowed' warnings to WARNINGS",
		Vector2i(100,100),
		func() -> void:change_shadowed_warnings(false)
		)]
	)
	
	vbox.add_child(shadow_warning_container)
	vbox.add_child(add_static_line_edit_with_text(Vector2i(10,10),"[<Stretch modes>]"))

	# TODO add method for options
	vbox.add_child(add_button("Set Stretch mode 'disabled'",default_ui_size, func() -> void : change_stretch_mode(StretchModes.disabled)))
	vbox.add_child(add_button("Set Stretch mode 'canvas_items'",default_ui_size,func() -> void : change_stretch_mode(StretchModes.canvas_items)))
	vbox.add_child(add_button("Set Stretch mode 'viewport'",default_ui_size, func() -> void : change_stretch_mode(StretchModes.viewport))) 
	
	vbox.add_child(add_static_line_edit_with_text(Vector2i(100,10),"[<Default texture filter modes>]"))

	vbox.add_child(add_button("Set default texture filter 'Nearest'(best for pixel art)",default_ui_size, func() -> void : change_filter_mode(FilterModes.Nearest)))
	vbox.add_child(add_button("Set default texture filter 'Linear'(best for everything else)",default_ui_size, func() -> void : change_filter_mode(FilterModes.Linear)))
	vbox.add_child(add_button("Set default texture filter 'Nearest Mipmap'(best for everything else)",default_ui_size, func() -> void : change_filter_mode(FilterModes.Nearest_Mipmap)))
	vbox.add_child(add_button("Set default texture filter 'Linear Mipmap'(best for everything else)",default_ui_size, func() -> void : change_filter_mode(FilterModes.Linear_Mipmap)))

	
	window.add_child(control)
	pass

func change_stretch_mode(which_mode : StretchModes ) -> void:
	var current_mode:String = ProjectSettings.get_setting("display/window/stretch/mode","PROJECT SETTINGS ERROR")
	var which_mode_str: String = str(StretchModes.keys()[which_mode])
	print("Stretch mode = %s" % which_mode_str)
	if current_mode == which_mode_str: return;
	ProjectSettings.set_setting("display/window/stretch/mode", which_mode_str)

func change_filter_mode(which_mode:FilterModes) -> void:
	var current_mode:String = str(ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter","COULD NOT GET DEFAULT TEXTER FILTER"))
	var which_mode_str:String = FilterModes.keys()[which_mode]
	var are_same_mode : bool = current_mode == which_mode_str
	if are_same_mode:
		print("filter mode ALREADY set to %s" % which_mode_str)
		return;
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter",which_mode)
	ProjectSettings.save()
	print("filter mode set to %s" % which_mode_str)
	return

func callable_info_print(call_back_function: Callable) -> void:
	print("is null = %s"% call_back_function.is_null())
	print("is valid = %s" % call_back_function.is_valid())
	print("is custom = %s" % call_back_function.is_custom())
	print("is standard = %s" % call_back_function.is_standard())
	print("method is = %s" % call_back_function.get_method())
	print("call argument count is = %s" % call_back_function.get_argument_count())
	pass

func change_viewport_size(should_change_width : bool , new_size:int) -> void:
	if should_change_width:
		print("change width = %s" % new_size)
		ProjectSettings.set_setting("display/window/size/viewport_width", new_size)
	else:
		print("change height = %s" % new_size)
		ProjectSettings.set_setting("display/window/size/viewport_height", new_size)
	pass

func change_shadowed_warnings(to_errors : bool) -> void:
	var what_value_to_set:int = 2 if to_errors else 1
	var shadowed_global_identifier : String = "debug/gdscript/warnings/shadowed_global_identifier";
	var shadowed_variable : String= "debug/gdscript/warnings/shadowed_variable";
	var shadowed_variable_base_class:String = "debug/gdscript/warnings/shadowed_variable_base_class"
	
	if to_errors:
		print("Change 'shadowed' warnings to ERRORS ")
	else:
		print("Change 'shadowed' warnings to WARNINGS ")
	
	var settings_to_change : Array[String] = [shadowed_global_identifier,
											  shadowed_variable,
											  shadowed_variable_base_class]
	for i in settings_to_change:
		if ProjectSettings.has_setting(i):
			ProjectSettings.set_setting(i,what_value_to_set)
		else:
			printerr("SETTING DOES NOT EXIST =|%s|" % i)
