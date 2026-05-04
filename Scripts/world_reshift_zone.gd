extends Area3D

@export var map: Map


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		
		# shift world and player back down to avoid floating point problems
		(body as Node3D).global_position.y -= 5.0
		map.shift_platforms(Vector3(0, -5, 0))

		# spawn new platforms
		for i: int in range(10):
			map.add_new_platform()
