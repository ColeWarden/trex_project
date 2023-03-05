extends Node2D
class_name Projectile

var speed: float = 5.0
var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2
onready var sprite: Sprite = $Sprite


func set_direction(dir: Vector2)-> void:
	direction = dir.normalized()
	sprite.look_at(dir + global_position)
	
	if direction.x < 0:
		sprite.flip_h = true
	update_velocity(direction, speed)


func set_speed(spd: float)-> void:
	speed = spd
	update_velocity(direction, speed)


func update_velocity(dir: Vector2, spd: float)-> void:
	velocity = dir * spd


func _process(delta: float) -> void:
	sprite.rotation_degrees = sin(global_position.x * delta * 8) * 15
	global_position += velocity * delta


func _on_Area2D_body_entered(body: Node) -> void:
	if body is TileMap:
		queue_free()
