class_name Player
extends CharacterBody3D

@export_category("Setup")
@export var map_to_rotate: Map
@export var base: Node3D
@export var ui: Game_UI

@export_category("Movement")
@export var speed: float = 5.0
@export var jump_velocity = 4.5
@export var gravity_force: float = -12
@export var lowered_gravity_force: float = -6

var started: bool = false
var usable_collectable: Collectable.Type
var active_collectable: Collectable.Type
@onready var collectable_use_timer: Timer = $"Collectable Use Timer"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		if active_collectable == Collectable.Type.LOW_GRAVITY:
			velocity += Vector3(0, lowered_gravity_force, 0) * delta
		else:
			velocity += Vector3(0, gravity_force, 0) * delta
	elif started:
		#jump()
		pass

	# Handle jump.
	if not started and Input.is_action_just_pressed("ui_accept"):
		ui.hide_start_prompt()
		jump()
		started = true
		if base:
			base.call_deferred("queue_free")
	
	if Input.is_action_just_pressed("ui_accept") and usable_collectable != Collectable.Type.EMPTY:
		match usable_collectable:
			Collectable.Type.EXTRA_JUMP:
				jump()
			Collectable.Type.LOW_GRAVITY:
				active_collectable = Collectable.Type.LOW_GRAVITY
				collectable_use_timer.start()
				
		usable_collectable = Collectable.Type.EMPTY
		ui.set_collectable(Collectable.Type.EMPTY)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if started:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		input_dir.y = 0.0
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			map_to_rotate.rotation_degrees.y +=  -direction.x * speed * delta

	move_and_slide()
	

func jump()->void:
	velocity.y = jump_velocity

func pickup_collectable(type: Collectable.Type)->void:
	usable_collectable = type
	ui.set_collectable(type)


func _on_collectable_use_timer_timeout() -> void:
	active_collectable = Collectable.Type.EMPTY
