class_name Player
extends KinematicBody2D

signal die(_self)

enum ANIM {
	IDLE,
	WALK,
	JUMP,
	DEATH,
	GHOST
}

const DEAD_ZONE_LIMIT = 0.5
const MAX_HORZ_VELOCITY = 2.0
const MAX_JUMP_VELOCITY = 8.0

const HORZ_VELOCITY = 1.0
const JUMP_VELOCITY = 9.0
const DOUBLE_JUMP_COOLDOWN = 0.5

var controller_id: int = -1 setget set_controller_id
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 0.4
var friction: float = 30.0
var animation_state: int = ANIM.IDLE
var jump_button_held: bool = false
var double_jump_ready: bool = false

onready var sprite: Sprite = $Sprite
onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animationPlayer.playback_speed = 10.0


func reset()-> void:
	set_animation(ANIM.IDLE)
	velocity = Vector2.ZERO
	double_jump_ready = false
	jump_button_held = false


func set_controller_id(value: int)-> void:
	controller_id = value


func _physics_process(delta: float) -> void:
	if animation_state == ANIM.DEATH or animation_state == ANIM.GHOST:
		global_position.y -= delta * 50.0
		return
	
	# Horz Movement
	velocity.x = _calculate_horz_movement(velocity.x, delta)
	
	# Vert Movement
	velocity.y = _calculate_jump_movement(velocity.y, delta)
	
	var clamped_x: float = clamp(velocity.x, -MAX_HORZ_VELOCITY, MAX_HORZ_VELOCITY)
	var clamped_y: float = clamp(velocity.y, -MAX_JUMP_VELOCITY, MAX_JUMP_VELOCITY)
	velocity = Vector2(clamped_x, clamped_y)
	velocity = move_and_slide(velocity, Vector2.UP, true)
	global_position += velocity


func _calculate_horz_movement(velocity_x: float, delta: float)-> float:
	var horz_dir: float = _get_horz_move_input()
	if abs(horz_dir) < DEAD_ZONE_LIMIT:
		horz_dir = 0.0
	if horz_dir != 0.0:
		if animation_state != ANIM.JUMP:
			set_animation(ANIM.WALK)
		sprite.flip_h = horz_dir > 0.0
		velocity_x += HORZ_VELOCITY * horz_dir
	else:
		if animation_state != ANIM.JUMP:
			set_animation(ANIM.IDLE)
		velocity_x = move_toward(velocity_x, 0.0, friction * delta)
	return velocity_x


func _calculate_jump_movement(velocity_y: float, _delta: float)-> float:
	# If jump is ready and B pressed
	var jumped: bool = _get_jump_input()
	
	# If not holding jump button, allow player to perform second jump
	if jump_button_held:
		if jumped == false:
			jump_button_held = false
			double_jump_ready = true
	
	# If on floor, player jump button is not held
	# If not on floor, apply gravity 
	var on_floor: bool = is_on_floor()
	if on_floor:
		if animation_state == ANIM.JUMP:
			set_animation(ANIM.IDLE)
		jump_button_held = false
	else:
		velocity_y += gravity
	
	# If holding jump key
	if jumped:
		if on_floor:
			# If on floor, double jump is false and jump button is held
			# Jump 
			double_jump_ready = false
			jump_button_held = true
			set_animation(ANIM.JUMP)
			velocity_y = -JUMP_VELOCITY
			#global_position.y -= 1
		elif double_jump_ready:
			# If pressed double rump ready and jumped, double jump
			double_jump_ready = false
			set_animation(ANIM.JUMP)
			velocity_y = -JUMP_VELOCITY
			#global_position.y -= 1
	
	# If not holding jump and player is moving up, set velocity to 0 and let player fall
	if !jumped and velocity_y < 0:
		velocity_y += gravity
		#velocity_y = 0
	
	return velocity_y


func _get_jump_input()-> bool:
	if controller_id != -1:
		return Input.is_joy_button_pressed(controller_id, JOY_XBOX_B)
	else:
		return Input.is_action_pressed("space")


func _get_horz_move_input()-> float:
	if controller_id != -1:
		return Input.get_joy_axis(controller_id, JOY_ANALOG_LX)
	else:
		return float(Input.is_action_pressed("d")) -  float(Input.is_action_pressed("a"))


func set_animation(anim_state: int):
	animation_state = anim_state
	if animation_state == ANIM.IDLE:
		animationPlayer.play("idle")
	elif animation_state == ANIM.WALK:
		animationPlayer.play("walk")
	elif animation_state == ANIM.JUMP:
		animationPlayer.play("jump")
	elif animation_state == ANIM.DEATH:
		animationPlayer.play("death")
	elif animation_state == ANIM.GHOST:
		animationPlayer.play("ghost")


func _die()-> void:
	set_animation(ANIM.DEATH)


func _ghost()-> void:
	set_animation(ANIM.GHOST)


func _area_entered(area) -> void:
	var parent = area.get_parent()
	if parent is Checkpoint:
		parent.set_current_checkpoint()
	else:
		_ghost()
		emit_signal("die", self)
