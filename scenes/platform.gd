extends Node2D

onready var from: Vector2 = global_position
onready var to: Vector2 = global_position + Vector2(32, -32)

var flip: bool = false

func _physics_process(delta: float) -> void:
	var global_y: float =  global_position.y
	var speed = 20.0 * delta 
	if flip:
		speed *= -1
	
	if global_y < to.y:
		flip = false
	elif global_y > from.y:
		flip = true
	global_position += Vector2(speed, speed)#$KinematicBody2D.move_and_slide(Vector2(speed, speed))#, Vector2.ONE)
	#Vector2(speed, speed)


