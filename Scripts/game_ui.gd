class_name Game_UI
extends CanvasLayer

signal blend_out_finished

@onready var blending_color_rect: ColorRect = $"Blending ColorRect"
@export var blend_duration: float = 0.5 
var tween: Tween
@onready var collectable_texture_rect: TextureRect = $"Collectable VBox/Collectable TextureRect"
@onready var collectable_label: Label = $"Collectable VBox/Collectable Label"
@export var collectables_textures: Dictionary[Collectable.Type, Texture]
@export var collectables_names: Dictionary[Collectable.Type, String]

func _ready() -> void:
	blend_in_game()

func blend_in_game()->void:
	if tween:
		tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(blending_color_rect, "color:a", 0, blend_duration)

func blend_out_screen()->void:
	if tween:
		tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(blending_color_rect, "color:a", 1, blend_duration)
	
	tween.finished.connect(_on_blend_out_tween_finished)

func _on_blend_out_tween_finished()->void:
	blend_out_finished.emit()

func _exit_tree() -> void:
	if tween:
		tween.stop()

func set_collectable(type: Collectable.Type)->void:
	collectable_texture_rect.texture = collectables_textures[type]
	collectable_label.text = collectables_names[type]
