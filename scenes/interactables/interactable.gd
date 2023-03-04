tool
class_name Interactable
extends Node2D


onready var sprite: Sprite = $Sprite

func set_sprite_frame(frame: int)-> void:
	sprite.frame = frame
