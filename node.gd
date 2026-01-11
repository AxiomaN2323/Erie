extends Node

@onready var player = $Player

@onready var babyscream = $babyscream


func _ready():
	player.babyscream_signal.connect(_on_player_scream)
	player.increasaenoise_signal.connect(_on_player_scream)

func _on_player_scream():
	babyscream.play()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		$CanvasLayer/CRT_shader.material.shader_parameter("static_noise_intensity", 0.3)
