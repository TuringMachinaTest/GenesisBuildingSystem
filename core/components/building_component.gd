class_name BuildingComponent

extends Node


@export var test_selected_block: Block
@export var allowBlock_ghost_material: Material
@export var deny_ghost_material: Material
@export var ray_length: int = 1000

var player: BaseCharacter
var camera: Camera3D

var ghost_block: BaseBlock

var build_mode: bool = false

var ray_casting_space_state
var ray_casting_mouse_position
var ray_casting_origin
var ray_casting_end
var ray_casting_query
var ray_casting_result
var ray_casting_result_block: BaseBlock

func _ready() -> void:
	player = get_parent()
	camera = player.character_camera_controller.camera


func toggle_build_mode() -> void:
	build_mode = !build_mode
	if build_mode:
		spawn_ghost_block()
	else:
		destroy_ghost_block()


func spawn_ghost_block() -> void:
	ghost_block = test_selected_block.block_scene.instantiate()
	add_child(ghost_block)
	
	ghost_block.set_material(allowBlock_ghost_material)
	ghost_block.disable_collisions()
	


func destroy_ghost_block() -> void:
	ghost_block.queue_free()


func spawn_block() -> void:
	if build_mode and ray_casting_result:
		var block: BaseBlock = test_selected_block.block_scene.instantiate()
		block.global_transform = ghost_block.global_transform
		player.get_parent().add_child(block)


func destroy_block() -> void:
	if build_mode and ray_casting_result:
		# TODO: Improve get_parent sollution
		if ray_casting_result.collider.get_parent().get_parent() is BaseBlock:
			ray_casting_result.collider.get_parent().get_parent().queue_free()


func _physics_process(delta):

	if build_mode:
		ray_casting_space_state = player.get_world_3d().direct_space_state
		ray_casting_mouse_position = player.get_viewport().get_mouse_position()

		ray_casting_origin = camera.project_ray_origin(ray_casting_mouse_position)
		ray_casting_end = ray_casting_origin + camera.project_ray_normal(ray_casting_mouse_position) * ray_length
		ray_casting_query = PhysicsRayQueryParameters3D.create(ray_casting_origin, ray_casting_end)
		ray_casting_query.exclude = [player, ghost_block]

		ray_casting_query.collide_with_areas = true
		ray_casting_result = ray_casting_space_state.intersect_ray(ray_casting_query)

		if  ray_casting_result:
			ghost_block.global_transform.origin = ray_casting_result.position
			if ray_casting_result:
				# TODO: Improve get_parent sollution
				if ray_casting_result.collider.get_parent().get_parent() is BaseBlock:

					ray_casting_result_block = ray_casting_result.collider.get_parent().get_parent()
					ghost_block.global_transform = ray_casting_result_block.get_snaped_transform(ghost_block)
					ghost_block.set_material(allowBlock_ghost_material)
				else:
					ghost_block.set_material(deny_ghost_material)
			else:
				ghost_block.set_material(deny_ghost_material)
