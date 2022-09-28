tool
extends EditorPlugin

var button: ToolButton
var selectedControl: Control

func _enter_tree():
	get_editor_interface().get_selection().connect("selection_changed", self, "on_editor_selection_changed")
	button = ToolButton.new()
	button.text = "Center Pivot Offset"

	var iconTexture = preload("icon/align_center.svg") as Texture
	button.icon = iconTexture
	button.expand_icon = false
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
	button.connect("pressed", self, "on_button_pressed")
	button.visible = false

	update_node_selection()

func _exit_tree():
	button.queue_free()

func update_node_selection():
	var selectedNodes = get_editor_interface().get_selection().get_selected_nodes()
	var isControlSelected = selectedNodes.size() == 1 && selectedNodes[0] is Control
	button.visible = isControlSelected
	if isControlSelected:
		selectedControl = selectedNodes[0]
	else:
		selectedControl = null
	button.visible = selectedControl != null

func on_editor_selection_changed():
	update_node_selection()

func on_button_pressed():
	if (selectedControl == null):
		push_warning("No control currently selected for centering pivot offset!")
		return
	selectedControl.rect_pivot_offset = selectedControl.rect_size / 2
	print('Updated pivot_offset for control %s' % selectedControl.name)
