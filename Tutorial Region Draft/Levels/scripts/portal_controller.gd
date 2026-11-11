extends Node

# Controller to lock/unlock the room's progression portal when local enemies are cleared.
# Place as a child of the room root so it can inspect the room's nodes.

@onready var portal: Node = null
var watched_enemies: Array[Node] = []

func _ready() -> void:
	portal = get_parent().get_node_or_null("portalProgression")
	if portal == null:
		portal = get_parent().get_node_or_null("portal2")
	if portal == null:
		portal = get_parent().get_node_or_null("portal")

	_collect_watched_enemies(get_parent())
	for enemy in watched_enemies:
		if is_instance_valid(enemy):
			enemy.tree_exited.connect(Callable(self, "_on_enemy_tree_exited").bind(enemy))

	# initial lock if any room-clear enemies are present
	if watched_enemies.size() > 0:
		if portal and portal.has_method("toggle_lock"):
			if not bool(portal.get("locked")):
				portal.toggle_lock()
	else:
		_unlock_portal()


func _collect_watched_enemies(n: Node) -> void:
	for ch in n.get_children():
		if ch.is_in_group("Enemy") and bool(ch.get("counts_for_room_clear")):
			watched_enemies.append(ch)
		_collect_watched_enemies(ch)


func _on_enemy_tree_exited(enemy: Node) -> void:
	if watched_enemies.has(enemy):
		watched_enemies.erase(enemy)
	if watched_enemies.size() == 0:
		_unlock_portal()


func _unlock_portal() -> void:
	if portal == null:
		return
	if portal.has_method("toggle_lock"):
		if bool(portal.get("locked")):
			portal.toggle_lock()
