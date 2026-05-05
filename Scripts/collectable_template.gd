class_name Collectable
extends Area3D

enum Type{
	EMPTY,
	EXTRA_JUMP,
	LOW_GRAVITY
}
@export var type: Type


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		(body as Player).pickup_collectable(type)
		call_deferred("queue_free")
