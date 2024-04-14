class_name Sockets
extends Node3D


func get_sockets() -> Array[Socket]:
    var sockets: Array[Socket] = []
    for child in get_children():
        sockets.append(child)
    return sockets