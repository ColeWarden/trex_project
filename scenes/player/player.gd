extends KinematicBody2D


const MAX_HORZ_VELOCITY = 5.0
const MAX_JUMP_VELOCITY = 9.0

const HORZ_VELOCITY = 5.0
const JUMP_VELOCITY = 9.0

var controller_id: int = -1 setget set_controller_id
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 0.5
var friction: float = 300.0

onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	set_process(false)


func set_controller_id(value: int)-> void:
	controller_id = value
	set_process(controller_id != -1)


func _process(delta: float) -> void:
	var horz_dir: float = 0.0
	
	# Horz Movement
	horz_dir = sign(Input.get_joy_axis(controller_id, JOY_ANALOG_LX))
	if horz_dir != 0.0:
		velocity.x += HORZ_VELOCITY * horz_dir
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	# Vert Movement
	# If jump is ready and B pressed 
	velocity.y += gravity
#	if $RayCast2D.is_colliding():
#		velocity.y = 0.0
#	var collision_pos: Vector2 = collisionShape2D.global_position
#	var rectShape: RectangleShape2D = collisionShape2D.shape
#	var extents: Vector2 = rectShape.extents
#	var bottom_left_pos: Vector2 = collision_pos + Vector2(-extents.x, extents.y)
#	var bottom_right_pos: Vector2 = collision_pos + Vector2(extents.x, extents.y)
#	var slides: int = get_slide_count()
#	var on_ground: bool = slides != 0
#	for slide in slides:
#		var collision: KinematicCollision2D = get_slide_collision(slide)
#		var pos: Vector2 = collision.position + Vector2(8,8)
#		var on_ground_tile: bool = false
#		if pos.x < collision_pos.x:
#			on_ground_tile = abs(bottom_left_pos.direction_to(pos).x) <= PI/4
#		else:
#			on_ground_tile = abs(bottom_right_pos.direction_to(pos).x) <= PI/4
#		if !on_ground_tile:
#			on_ground = false
#			break
#
#	if is_on_floor():
#		velocity.y = 0.0
	#print(velocity)
	
	if Input.is_joy_button_pressed(controller_id, JOY_XBOX_B) and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		#velocity.y -= JUMP_VELOCITY
	
	var clamped_x: float = clamp(velocity.x, -MAX_HORZ_VELOCITY, MAX_HORZ_VELOCITY)
	var clamped_y: float = clamp(velocity.y, -MAX_JUMP_VELOCITY, MAX_JUMP_VELOCITY)
	velocity = Vector2(clamped_x, clamped_y)
	velocity = move_and_slide(velocity, Vector2.UP, true)
	global_position += velocity
