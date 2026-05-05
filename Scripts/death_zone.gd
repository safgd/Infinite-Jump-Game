extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("Game Over")
		get_tree().call_deferred("reload_current_scene")


func _on_area_entered(area: Area3D) -> void:
	if area is Platform:
		(area as Platform).destroy()
