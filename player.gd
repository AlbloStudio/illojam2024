class_name player extends CharacterBody3D

@export var speed = 300.0
@export var acceleration := 10.0
@export var intertia := 15.0

var desired_velocity := Vector2.ZERO


func _ready():
	desired_velocity = Vector2.LEFT


func _physics_process(delta: float) -> void:
	calculate_velocity(delta)
	
	move_and_slide()


func calculate_velocity(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector(
		"player_left", "player_right", "player_up", "player_down"
	)
	
	var input_direction_3d = Vector3(input_direction.x, 0.0,  input_direction.y)

	if input_direction_3d != Vector3.ZERO:
		velocity = lerp(velocity, input_direction_3d * speed, acceleration * delta)
		print(velocity)		
	else:
		velocity = lerp(velocity, Vector3.ZERO, intertia * delta)
