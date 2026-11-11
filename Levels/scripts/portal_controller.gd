extends Node

# Controller to lock/unlock the room's progression portal when local enemies are cleared.
# Place as a child of the room root so it can inspect the room's nodes.

@onready var portal := null
var watched_enemies: Array[Node] = []

func _ready() -> void:
	portal = get_parent().get_node_or_null("portalProgression")
	if portal == null:
		portal = get_parent().get_node_or_null("portal")

	_collect_watched_enemies(get_parent())

	# initial lock if any room-clear enemies are present
	if watched_enemies.size() > 0:
		if portal and portal.has_method("toggle_lock"):
			if not portal.locked:
				portal.toggle_lock()

	# watch for removed nodes to detect enemy death
	get_tree().connect("node_removed", Callable(self, "_on_node_removed"))


func _collect_watched_enemies(n: Node) -> void:
	for ch in n.get_children():
		if ch.is_in_group("Enemy") and bool(ch.get("counts_for_room_clear")):
			watched_enemies.append(ch)
		_collect_watched_enemies(ch)


func _on_node_removed(node: Node) -> void:
	if not node.is_in_group("Enemy"):
		return
	if not bool(node.get("counts_for_room_clear")):
		return
	# only care about enemies that belong to this room
	if node.get_owner() != get_parent():
		return
	if watched_enemies.has(node):
		watched_enemies.erase(node)
	if watched_enemies.size() == 0:
		_unlock_portal()


func _unlock_portal() -> void:
	if portal == null:
		return
	if portal.has_method("toggle_lock"):
		if portal.locked:
			portal.toggle_lock()

