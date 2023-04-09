@tool
extends Control


func _ready():
	child_entered_tree.connect(on_child_entered_tree)
	child_exiting_tree.connect(on_child_exiting_tree)
	update_deferred()


func update():
	var rect = Rect2()
	for child in get_children():
		if child is Control:
			child.size = Vector2.ZERO
			var expand_rect = Rect2(child.position, child.size)
			rect = rect.merge(expand_rect)
	custom_minimum_size = rect.size
	size = Vector2.ZERO


func update_deferred():
	update.call_deferred()


func on_child_entered_tree(node: Node):
	if node is Control:
		if Engine.is_editor_hint() && !node.is_connected("item_rect_changed", update_deferred):
			node.item_rect_changed.connect(update_deferred)
	

func on_child_exiting_tree(node: Node):
	update_deferred()
