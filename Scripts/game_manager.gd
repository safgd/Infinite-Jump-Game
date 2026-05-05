class_name Game_Manager
extends Node

@export var game_scene: PackedScene
var game: Node
static var instance: Game_Manager
static var is_first_load: bool = true

@onready var shader_precash_nodes: Node = $"Shader Precash Nodes"
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	_instantiate_game()

static func reload_game()->void:
	if instance.game:
		instance.game.call_deferred("queue_free")
	instance._instantiate_game()

static func remove_precash_nodes_early()->void:
	if instance.shader_precash_nodes:
		instance.timer.stop()
		instance._on_timer_timeout()

func _instantiate_game()->void:
	game = game_scene.instantiate()
	add_child(game)


func _on_timer_timeout() -> void:
	shader_precash_nodes.call_deferred("queue_free")
