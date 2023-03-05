extends Node2D

export(float) var projectile_speed = 100.0
export(Vector2) var projectile_direction = Vector2.RIGHT
export(float) var fire_rate = 1.0

var counter: float = 0.0
var world: Node2D

onready var timer: Timer = $Timer
onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animationPlayer.playback_speed = 10.0
	yield(get_tree().create_timer(rand_range(0.0, fire_rate)), "timeout")
	timer.start(fire_rate)


func get_world()-> Node2D:
	return get_tree().get_nodes_in_group("world").front()


func _shoot_projectile()-> void:
	shoot_projectile(projectile_direction, projectile_speed)


func shoot_projectile(direction: Vector2, spd: float)-> void:
	if !world:
		world = get_world()
	var inst: Projectile = world.create_projectile(direction, spd)
	var offset = Vector2(8, -12)
	inst.global_position = global_position + offset


func start_animation()-> void:
	if !animationPlayer.is_playing():
		animationPlayer.play("fire")
