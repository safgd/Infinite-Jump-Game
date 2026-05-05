class_name Map
extends Node3D

@export var platform_scene: PackedScene
@export var collectable_scenes: Array[PackedScene]
## Defines the circle where platforms are spawned on
@export var radius: float = 5.0
@export var plat_dist_x: float = 40.0
@export var plat_dist_y: float = 3.0

@onready var platforms: Node3D = $Platforms
@onready var collectables: Node3D = $Collectables



var platform_tokens = 20

var last_plat: Platform

# unused so far, could be used to track progress
var difficulty_level: int = 0

@export_category("Random Factors")
## chance for any platform to be breakable
@export var breakable_condition_value: float = 0.1
## chance for any platform to be a moving one
@export var movable_condition_value: float = 0.1
## chance for any non-moving platform to be a flipping one
@export var flipping_condition_value: float = 0.1
## chance for collectables to spawn on any non-moving or non_flipping platform
@export var collectable_spawn_value: float = 0.1

func _ready() -> void:
	for i: int in range(10):
		
		add_new_platform()

func shift_platforms_and_collectables(offset: Vector3)->void:
	for child: Node in platforms.get_children():
		if child is Platform:
			(child as Platform).global_position += offset
	for child: Node in collectables.get_children():
		if child is Collectable:
			(child as Collectable).global_position += offset
			

func add_new_platform()->void:
	if platform_tokens > 0:
		platform_tokens -= 1
	else:
		#print("no platform tokens left")
		return
	
	var new_plat: Platform
	if last_plat:
		new_plat = last_plat.duplicate()
	else:
		new_plat = platform_scene.instantiate()
	
	platforms.add_child(new_plat)
	new_plat.reset()
	new_plat.parent_map = self
	new_plat.global_position.y += plat_dist_y
	var new_rotation: float = new_plat.rotation_degrees.y
	if randf() < 0.5:
		new_rotation += plat_dist_x
	else:
		new_rotation -= plat_dist_x
	new_rotation = floori(new_rotation) % 360
	new_plat.rotation_degrees.y = new_rotation
	
	
	if randf() < movable_condition_value:
		new_plat.start_moving()
	elif randf() < flipping_condition_value:
		new_plat.start_flipping()
	elif randf() < collectable_spawn_value:
		var collectable: Collectable = collectable_scenes[randi() % collectable_scenes.size()].instantiate()
		collectables.add_child(collectable)
		collectable.global_position = new_plat.collectable_spawn_slot.global_position
		collectable.global_rotation = new_plat.collectable_spawn_slot.global_rotation
	if randf() < breakable_condition_value:
		new_plat.breakable = true

	
	last_plat = new_plat
	
func increase_difficulty_level()->void:
	difficulty_level += 1
	breakable_condition_value = clampf(breakable_condition_value, breakable_condition_value + 0.05, 1.0)
	movable_condition_value = clampf(movable_condition_value, movable_condition_value + 0.05, 1.0)
	flipping_condition_value = clampf(flipping_condition_value, movable_condition_value + 0.05, 1.0)
