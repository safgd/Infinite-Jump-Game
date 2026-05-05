class_name Platform
extends Area3D

var move_tween: Tween
@export var move_dist: float = 4.0
@export var loop_duration: float = 2.0
@export var breakable: bool = false
var parent_map: Map
@onready var collectable_spawn_slot: Marker3D = $"Collectable Spawn Slot"

func start_moving()->void:
	move_tween = get_tree().create_tween().set_loops()
	var start_rotation: float = rotation.y
	move_tween.tween_property(self, "rotation:y", start_rotation + move_dist, loop_duration / 2.0)
	move_tween.tween_property(self, "rotation:y", start_rotation - move_dist, loop_duration / 2.0)
	
func _exit_tree() -> void:
	if move_tween:
		move_tween.stop()

func destroy()->void:
	parent_map.platform_tokens += 1
	call_deferred("queue_free")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		(body as Player).jump()

func _on_body_exited(body: Node3D) -> void:
	if breakable and body is Player and body.global_position.y > global_position.y:
		destroy()
