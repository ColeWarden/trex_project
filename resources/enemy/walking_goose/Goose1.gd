extends KinematicBody2D

enum ANIM {
	IDLE,
	WALK,
	JUMP
}

var direction = Vector2.RIGHT # (1, 0)
var velocity = Vector2.ZERO

var animation_state: int = ANIM.IDLE

onready var ledgeCheck: = $LedgeCheck


func _physics_process(delta):
	
	var animation_state: int = ANIM.IDLE
	
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheck.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
	
	$AnimatedSprite.flip_h = direction.x > 0
	
	
	velocity = direction * 25
	
	move_and_slide(velocity, Vector2.UP)
	
	#if velocity > 0:
	#	set.animation_state = 
	
	
