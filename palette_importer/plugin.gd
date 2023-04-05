@tool
extends EditorPlugin

var button: Button

func _enter_tree():
	button = Button.new()
	button.text = "Load Palette"
	button.pressed.connect(on_load_palette_pressed)

	add_control_to_dock(DOCK_SLOT_LEFT_UL, button)


func _exit_tree():
	remove_control_from_docks(button)
	button.free()


func load_image_into_palette(path: String):
	var image = Image.new()
	image.load(path)
	
	var color_dictionary = {}
	
	for x in image.get_width():
		for y in image.get_height():
			var color = image.get_pixelv(Vector2i(x, y))
			color_dictionary[color.to_html()] = color

	var settings = get_editor_interface().get_editor_settings()
	var arr: PackedColorArray = []
	for key in color_dictionary.keys():
		arr.append(color_dictionary[key])
	settings.set_project_metadata("color_picker", "presets", arr)


func on_load_palette_pressed():
	print("yo")
