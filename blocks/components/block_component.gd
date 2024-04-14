class_name BlockComponent
extends Node


@export var sockets_node: Sockets


var sockets: Array[Socket]


func _ready() -> void:
	sockets = sockets_node.get_sockets()


func find_best_snap_transform(block_to_spawn: BaseBlock) -> Transform3D:
	return get_parent().global_transform

	# return get_parent().global_transform
