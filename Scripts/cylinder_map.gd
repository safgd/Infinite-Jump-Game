extends Node3D

@export var platform_scene: PackedScene
@export var radius: float = 5.0
@onready var platforms: Node3D = $Platforms

func _ready() -> void:
	for i: int in range(10):
		spawn_platform()

func spawn_platform()->void:
	var plat = platform_scene.instantiate()
	platforms.add_child(plat)
	var direction: Vector2 = (Vector2(randi(), randi())).normalized() * radius
	var y: float = randi() % 10
	plat.global_position = Vector3(direction.x, y, direction.y)
