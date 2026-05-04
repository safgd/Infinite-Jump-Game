class_name Platform
extends StaticBody3D

var move_tween: Tween
@export var move_dist: float = 4.0
@export var loop_duration: float = 2.0
@export var breakable: bool = false

func start_moving()->void:
	move_tween = get_tree().create_tween().set_loops()
	var start_rotation: float = rotation.y
	move_tween.tween_property(self, "rotation:y", start_rotation + move_dist, loop_duration / 2.0)
	move_tween.tween_property(self, "rotation:y", start_rotation - move_dist, loop_duration / 2.0)
	
func _exit_tree() -> void:
	if move_tween:
		move_tween.stop()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		call_deferred("queue_free")
