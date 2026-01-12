extends CharacterBody3D


signal walking_started
signal walking_stopped
signal running_started
signal running_stopped

# STAMINA
var stamina := 100.0
var staminadrainrate := 50.0
var staminabackrate := 30.0

# MOVIMIENTO
var can_run := true

var walking = false
var running = false

# FISICAS
var GRAVEDAD := 9.8 * 3

var RUN_SPEED := 6.0
var SPEED := 3.0

var mouse_sensitivity := 0.3
var vertical_look := 0.0

@onready var camera_pivot = $Pivot/TwistPivot/PitchPivot/Camera3D

func _ready():
	# Esto captura el raton al centro de la pantalla y no te deja moverlo
	# Para que no se vaya fuera de la ventana o del juego
	# y se consiguen los ejes del raton de paso
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		vertical_look = clamp(vertical_look - event.relative.y * mouse_sensitivity,-90,90)
		camera_pivot.rotation_degrees.x = vertical_look

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	
			
func _physics_process(delta):
	# was_walking se crea para conseguir el estado anterior de walking
	var was_walking :bool
	was_walking = walking
	var was_running :bool
	was_running = running
	
	# --- GRAVEDAD ---
	if not is_on_floor():
		# IMPORTANTE esto solo funciona gracias a move_and_slide()
		# Si no velocity no se emplearia
		velocity.y -= GRAVEDAD * delta
	else:
		velocity.y = 0

	# --- MOVIMIENTO ---
	var direction := Vector3.ZERO # Coordenadas x0 y0 z0 artificiales
	var forward = -transform.basis.z # Coordenada que siempre mira recto
	var right = transform.basis.x # Coordenada que siempre mira hacia un lado
	
	if Input.is_action_pressed("W"):
		direction += forward
	if Input.is_action_pressed("S"):
		direction -= forward
	if Input.is_action_pressed("A"):
		direction -= right
	if Input.is_action_pressed("D"):
		direction += right
	
	# Esto ayuda a que los valores no se vayan a la mierda y vayas muy rapido
	# El inconveniente de esto es que puede dar inputlag
	direction = direction.normalized()

	# Compruebo si me estoy moviendo con esto, esto comprueba si
	# direction es 0, 0, 0, en caso de que si, true, no, false
	walking = direction != Vector3.ZERO and not Input.is_action_pressed("Correr")
	running = direction != Vector3.ZERO and Input.is_action_pressed("Correr") and can_run
	
	if walking and not was_walking:
		walking_started.emit()
	elif not walking and was_walking:
		walking_stopped.emit()
		
	if running and not was_running:
		running_started.emit()
	elif not running and was_running:
		running_stopped.emit()
		
	# --- STAMINA / CORRER ---
	if Input.is_action_pressed("Correr") and can_run:
		SPEED = RUN_SPEED
		# La stamina se va restando poco a poco * los fps
		stamina -= staminadrainrate * delta
		stamina = max(stamina, 0)
		if stamina <= 1:
			can_run = false
	else:
		SPEED = 3
		# La stamina se va sumando poco a poco * los fps
		stamina += staminabackrate * delta
		stamina = min(stamina, 100)
		if stamina >= 100:
			can_run = true
	# ------------------------

	# En caso de que me pegue una ostia contra una pared me paro en el eje x
	if is_on_wall():
		velocity.x = 0

	# IMPORTANTE, esto solo funciona gracias a que se usa 
	# move_and_slide() function 
	# Si no, no se usarian los valores de velocity
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()

# IMPORTANTE, todo lo que sean fisicas NO VAN AQUI
# _PROCESS SE PROCESA CADA FRAME
# _delta es solo si no se va a usar
# delta son frames normalizados, en caso de que el juego vaya mal por specs
func _process(_delta: float) -> void:
	pass
