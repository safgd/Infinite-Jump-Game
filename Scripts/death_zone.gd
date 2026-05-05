extends Area3D

@export var game_ui: Game_UI

func _ready() -> void:
	game_ui.blend_out_finished.connect(_on_death_screen_finished)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		game_ui.blend_out_screen()

func _on_area_entered(area: Area3D) -> void:
	if area is Platform:
		(area as Platform).destroy()
	elif area is Collectable:
		area.call_deferred("queue_free")

func _on_death_screen_finished()->void:
	print("Game Over")
	get_tree().call_deferred("reload_current_scene")
