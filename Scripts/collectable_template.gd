class_name Collectable
extends Area3D

enum Type{
	EMPTY,
	EXTRA_JUMP,
	LOW_GRAVITY,
	FREEZE
}
@export var type: Type
# extra safe guard, because the world shift can cause unintended pickups
@export var pickup_range: float = 2.0
func _on_body_entered(body: Node3D) -> void:
	if body is Player and (body.global_position - global_position).length() <= pickup_range:
		(body as Player).pickup_collectable(type)
		call_deferred("queue_free")
