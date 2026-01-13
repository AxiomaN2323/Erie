extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# MI JUGADOR
var player :CharacterBody3D

# Los rayos que hacen de ojos
@onready var raycast = $RayCast3D
var jugador_visto : bool
var jugador_viendo : bool
# AUDIO
@onready var chase_scream = $chase_scream

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _input(event):
	
	# si me ve gritito
	if jugador_visto:
		Chase_scream()
	
func _physics_process(delta: float) -> void:
	if player == null:
		return

	raycast.target_position = to_local(player.global_position)
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			jugador_visto = true
			print("te estoy viendo maricon")
		else:
			print("ps ya no te estoy viendo")
			jugador_visto = false
			return

	if jugador_viendo:
		Chase_scream()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func Chase_scream():
	if not chase_scream.playing:
		chase_scream.play()
	if chase_scream.playing:
		return
