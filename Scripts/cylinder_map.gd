extends Node3D

@export var platform_scene: PackedScene
@export var radius: float = 5.0
@onready var platforms: Node3D = $Platforms
@export var plat_dist_x: float = 40.0
@export var plat_dist_y: float = 3.0

func _ready() -> void:
	var plat_rotation: float = 0.0
	for i: int in range(50):
		var plat: Node3D = spawn_platform(i * plat_dist_y)
		if randf() < 0.5:
			plat_rotation += plat_dist_x
		else:
			plat_rotation -= plat_dist_x
		plat_rotation = floori(plat_rotation) % 360
		plat.rotation_degrees.y = plat_rotation

func spawn_platform(pos_y: float)->Node3D:
	var plat: Node3D = platform_scene.instantiate()
	platforms.add_child(plat)
	plat.global_position.y = pos_y
	return plat
