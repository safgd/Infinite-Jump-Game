extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Platform:
		(body as Platform).destroy()
	elif body is Player:
		print("Game Over")
		get_tree().call_deferred("reload_current_scene")
