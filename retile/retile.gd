tool
extends EditorPlugin

var button: ToolButton
var selectedTileMap: TileMap

func _enter_tree():
	get_editor_interface().get_selection().connect("selection_changed", self, "on_editor_selection_changed")
	button = ToolButton.new()
	button.text = "Re-tile"

	var iconTexture = preload("icon/hammer.svg") as Texture
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
	button.visible = selectedNodes.size() == 1 && selectedNodes[0] is TileMap
	if (selectedNodes.size() == 1 && selectedNodes[0] is TileMap):
		selectedTileMap = selectedNodes[0]
	else:
		selectedTileMap = null
	button.visible = selectedTileMap != null

func on_editor_selection_changed():
	update_node_selection()

func on_button_pressed():
	if (selectedTileMap == null):
		push_warning("No tilemap currently selected for re-tile!")
		return
	var rect = selectedTileMap.get_used_rect()
	selectedTileMap.update_bitmask_region(rect.position, rect.end)
	print('Updated autotile for tilemap %s' % selectedTileMap.name)
