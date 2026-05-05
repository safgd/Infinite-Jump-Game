class_name Game_Manager
extends Node

@export var game_scene: PackedScene
var game: Node
static var instance: Game_Manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	_instantiate_game()

static func reload_game()->void:
	if instance.game:
		instance.game.call_deferred("queue_free")
	instance._instantiate_game()

func _instantiate_game()->void:
	game = game_scene.instantiate()
	add_child(game)
