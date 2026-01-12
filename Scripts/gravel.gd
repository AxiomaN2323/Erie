extends CSGBox3D

signal gravel_walk_sound
signal gravel_walk_sound_stop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		gravel_walk_sound.emit()
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		gravel_walk_sound_stop.emit()
