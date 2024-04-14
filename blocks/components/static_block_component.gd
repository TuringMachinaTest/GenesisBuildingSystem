class_name  StaticBlockComponent

extends BlockComponent


func find_best_snap_transform(block_to_spawn: BaseBlock) -> Transform3D:
	var temp_distance = 50
	var closest_socket: Socket
	var closest_block_to_spawn_scoket: Socket
	var socket_distance
	for socket in sockets:
		socket_distance = socket.global_transform.origin.distance_to(block_to_spawn.global_position)
		if  socket_distance < socket.snap_distance and socket_distance < temp_distance:
			temp_distance = socket_distance
			closest_socket = socket
	if closest_socket:
		var result = closest_socket.global_transform
		result.origin += (closest_socket.transform.origin * block_to_spawn.size)
		return closest_socket.global_transform
	else:
		return get_parent().global_transform