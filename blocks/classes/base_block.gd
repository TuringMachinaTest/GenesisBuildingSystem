class_name BaseBlock

extends Node3D

@export var size: Vector3

var meshes: Array[MeshInstance3D]
var block_component: BlockComponent

var raw_transform: Transform3D
var modified_transform: Transform3D


func _ready() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		if child is BlockComponent:
			block_component = child


func set_material(material: Material) -> void:
	for mesh in meshes:
		for surface in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(surface, material)


func disable_collisions() -> void:
	for mesh in meshes:
		mesh.get_children()[0].get_children()[0].disabled = true


func enable_collisions() -> void:
	for mesh in meshes:
		mesh.get_children()[0].get_children()[0].disabled = false


func get_snaped_transform(block_to_spawn: BaseBlock) -> Transform3D:
	if block_component:
		return block_component.find_best_snap_transform(block_to_spawn)
	else:
		return global_transform
