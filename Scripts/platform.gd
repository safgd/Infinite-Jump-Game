class_name Platform
extends Area3D

@onready var flip_timer: Timer = $"Flip Timer"

@export var breakable_material: StandardMaterial3D
var breakable: bool = false:
	set(value):
		if value and value != breakable:
			mesh.set_surface_override_material(0, breakable_material)
		breakable = value
## describes the radiant angle, where the platform moves along
@export var move_dist: float = 4.0
@export var loop_duration: float = 2.0
var move_tween: Tween
## similar to move_dist
@export var flip_angle_distance: float = 2.0
var flipped: bool = false

var parent_map: Map
@onready var collectable_spawn_slot: Marker3D = $"Collectable Spawn Slot"
@onready var mesh: MeshInstance3D = $Mesh

func reset()->void:
	breakable = false
	mesh.set_surface_override_material(0, null)

func start_moving()->void:
	move_tween = get_tree().create_tween().set_loops()
	var start_rotation: float = rotation.y
	move_tween.tween_property(self, "rotation:y", start_rotation + move_dist, loop_duration / 2.0)
	move_tween.tween_property(self, "rotation:y", start_rotation - move_dist, loop_duration / 2.0)

func start_flipping()->void:
	flip_timer.start()

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

func _on_flip_timer_timeout() -> void:
	if flipped:
		rotation.y += flip_angle_distance
	else:
		rotation.y -= flip_angle_distance
	flipped = not flipped
