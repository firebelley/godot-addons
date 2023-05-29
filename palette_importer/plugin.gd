@tool
extends EditorPlugin

var container: VBoxContainer
var file_dialog: FileDialog

func _enter_tree():
	var button = Button.new()
	button.text = "Load Palette"
	button.pressed.connect(on_load_palette_pressed)
	button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	container = VBoxContainer.new()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, container)
	container.add_child(button)
	container.name = "Palette Loader"

	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	file_dialog.set_mode(FileDialog.MODE_WINDOWED)
	file_dialog.filters = ["*.png, *.jpg, *.jpeg ; Supported Images"]
	file_dialog.file_selected.connect(on_file_selected)
	file_dialog.current_path = "res://"
	add_child(file_dialog)


func _exit_tree():
	remove_control_from_docks(container)
	container.free()


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
	file_dialog.popup(Rect2(100, 100, 300, 500))


func on_file_selected(path):
	load_image_into_palette(path)
