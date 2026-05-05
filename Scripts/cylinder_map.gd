class_name Map
extends Node3D

@export var platform_scene: PackedScene
@export var radius: float = 5.0
@onready var platforms: Node3D = $Platforms
@export var plat_dist_x: float = 40.0
@export var plat_dist_y: float = 3.0
var platform_tokens = 20

var last_plat: Platform

# unused so far
var difficulty_level: int = 0

@export var breakable_condition_value: float = 0.1
@export var movable_condition_value: float = 0.1

func _ready() -> void:
	for i: int in range(10):
		
		add_new_platform()

func shift_platforms(offset: Vector3)->void:
	for child: Node in platforms.get_children():
		if child is Node3D:
			(child as Node3D).global_position += offset

func add_new_platform()->void:
	if platform_tokens > 0:
		platform_tokens -= 1
	else:
		#print("no platform tokens left")
		return
		
	if last_plat:
		last_plat = last_plat.duplicate()
	else:
		last_plat = platform_scene.instantiate()
	
	
	platforms.add_child(last_plat)
	last_plat.breakable = false
	last_plat.parent_map = self
	last_plat.global_position.y += plat_dist_y
	var new_rotation: float = last_plat.rotation_degrees.y
	if randf() < 0.5:
		new_rotation += plat_dist_x
	else:
		new_rotation -= plat_dist_x
	new_rotation = floori(new_rotation) % 360
	last_plat.rotation_degrees.y = new_rotation
	
	if randf() < movable_condition_value:
		last_plat.start_moving()
	if randf() < breakable_condition_value:
		last_plat.breakable = true
	
func increase_difficulty_level()->void:
	difficulty_level += 1
	breakable_condition_value = clampf(breakable_condition_value, breakable_condition_value + 0.05, 1.0)
	movable_condition_value = clampf(movable_condition_value, movable_condition_value + 0.05, 1.0)
