extends Node2D


onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animationPlayer.play("idle")
	animationPlayer.playback_speed = 5.0
	animationPlayer.seek(float(randi() % 4))
