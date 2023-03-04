extends KinematicBody2D

enum ANIM {
	IDLE,
	WALK,
	JUMP
}

const DEAD_ZONE_LIMIT = 0.5
const MAX_HORZ_VELOCITY = 2.0
const MAX_JUMP_VELOCITY = 8.0

const HORZ_VELOCITY = 1.0
const JUMP_VELOCITY = 9.0

var controller_id: int = -1 setget set_controller_id
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 0.5
var friction: float = 300.0
var animation_state: int = ANIM.IDLE


onready var sprite: Sprite = $Sprite
onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_process(false)
	animationPlayer.playback_speed = 10.0


func set_controller_id(value: int)-> void:
	controller_id = value
	set_process(controller_id != -1)


func _process(delta: float) -> void:
	# Horz Movement
	var horz_dir: float = Input.get_joy_axis(controller_id, JOY_ANALOG_LX)
	if abs(horz_dir) < DEAD_ZONE_LIMIT:
		horz_dir = 0.0
	if horz_dir != 0.0:
		if animation_state != ANIM.JUMP:
			set_animation(ANIM.WALK)
		sprite.flip_h = horz_dir > 0.0
		velocity.x += HORZ_VELOCITY * horz_dir
	else:
		if animation_state != ANIM.JUMP:
			set_animation(ANIM.IDLE)
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	if is_on_floor():
		if animation_state == ANIM.JUMP:
			set_animation(ANIM.IDLE)
	
	# Vert Movement
	# If jump is ready and B pressed 
	if Input.is_joy_button_pressed(controller_id, JOY_XBOX_B) and is_on_floor():
		set_animation(ANIM.JUMP)
		velocity.y = -JUMP_VELOCITY
	
	if !is_on_floor():
		velocity.y += gravity
	
	var clamped_x: float = clamp(velocity.x, -MAX_HORZ_VELOCITY, MAX_HORZ_VELOCITY)
	var clamped_y: float = clamp(velocity.y, -MAX_JUMP_VELOCITY, MAX_JUMP_VELOCITY)
	velocity = Vector2(clamped_x, clamped_y)
	velocity = move_and_slide(velocity, Vector2.UP, true)
	global_position += velocity


func set_animation(anim_state: int):
	animation_state = anim_state
	if animation_state == ANIM.IDLE:
		animationPlayer.play("idle")
	elif animation_state == ANIM.WALK:
		animationPlayer.play("walk")
	elif animation_state == ANIM.JUMP:
		animationPlayer.play("jump")
