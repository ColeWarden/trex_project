tool
class_name Interactable
extends Node2D

enum COLOR {
	RED,
	YELLOW,
	GREEN,
	BLUE,
}
const COLORS: PoolColorArray = PoolColorArray([Color.red, Color.yellow, Color.green, Color.blue])

export(COLOR) var color_mode: int = COLOR.RED

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	set_color_mode(color_mode)


func set_sprite_frame(frame: int)-> void:
	sprite.frame = frame


func set_sprite_mod_a(mod_a: float)-> void:
	sprite.modulate.a = mod_a


func set_color_mode(color: int)-> void:
	sprite.modulate = COLORS[color]
