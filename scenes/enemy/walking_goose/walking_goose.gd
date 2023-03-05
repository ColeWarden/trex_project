extends KinematicBody2D

var direction = Vector2.RIGHT
export(float) var speed: float = 25.0
var velocity = direction * speed


onready var ledgeCheck: = $LedgeCheck
onready var animationSprite: AnimatedSprite = $AnimatedSprite


func _ready() -> void:
	animationSprite.flip_h = direction.x > 0


func _physics_process(_delta: float):
	
	var found_wall = is_on_wall()
	var found_ledge = !ledgeCheck.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
		animationSprite.flip_h = direction.x > 0
		velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
