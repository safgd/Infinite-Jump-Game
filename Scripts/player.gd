extends CharacterBody3D

@export var map_to_rotate: Map

@export var speed: float = 5.0
@export var jump_velocity = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	input_dir.y = 0.0
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		map_to_rotate.rotation_degrees.y +=  -direction.x * speed * delta



	move_and_slide()
	
	if global_position.y >= 10:
		global_position.y -= 5.0
		map_to_rotate.shift_platforms(Vector3(0, -5, 0))
		print("shifted")
