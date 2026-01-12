extends Node3D

var walking := false
var running := false

enum surface { NONE, GRAVEL, WOOD}
var current_surface := surface.NONE

# AUDIOS
@onready var walking_on_gravel = $walking_on_gravel
@onready var running_on_gravel = $running_on_gravel
@onready var walking_on_wood = $walking_on_wood
@onready var running_on_wood = $running_on_wood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_parent()

	player.walking_started.connect(_walking_started)
	player.walking_stopped.connect(_walking_stopped)
	player.running_started.connect(_running_started)
	player.running_stopped.connect(_running_stopped)
	
	for gravel in get_tree().get_nodes_in_group("gravel"):
		gravel.gravel_walk_sound.connect(on_gravel_walk_sound)
		gravel.gravel_walk_sound_stop.connect(on_gravel_walk_sound_stop)
	for wood in get_tree().get_nodes_in_group("wood"):
		wood.wood_walk_sound.connect(on_wood_walk_sound)
		wood.wood_walk_sound_stop.connect(on_wood_walk_sound_stop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_gravel_walk_sound():
	current_surface = surface.GRAVEL
	update_walking_sound()
func on_gravel_walk_sound_stop():
	current_surface = surface.NONE
	stop_all_sounds()
func on_wood_walk_sound():
	current_surface = surface.WOOD
	update_walking_sound()
func on_wood_walk_sound_stop():
	current_surface = surface.NONE
	stop_all_sounds()

func _walking_started():
	walking = true
	update_walking_sound()
func _walking_stopped():
	walking = false
	stop_all_sounds()
func _running_started():
	running = true
	update_running_sound()
func _running_stopped():
	running = false
	stop_all_sounds()

func update_walking_sound():
	stop_all_sounds()

	if not walking:
		return

	match current_surface:
		surface.GRAVEL:
			walking_on_gravel.play()
		surface.WOOD:
			walking_on_wood.play()

func update_running_sound():
	stop_all_sounds()

	if not running:
		return

	match current_surface:
		surface.GRAVEL:
			running_on_gravel.play()
		surface.WOOD:
			running_on_wood.play()

func stop_all_sounds():
	walking_on_gravel.stop()
	walking_on_wood.stop()
	running_on_gravel.stop()
	running_on_wood.stop()
