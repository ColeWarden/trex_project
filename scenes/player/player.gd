extends KinematicBody2D


const MAX_HORZ_VELOCITY = 10.0
const MAX_JUMP_VELOCITY = 500.0

const HORZ_VELOCITY = 100.0
const JUMP_VELOCITY = 500.0

var controller_id: int = -1 setget set_controller_id
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 10.0
var friction: float = 300.0
var jump_ready: bool = true
var jump_cooldown_dur: float = 0.1
# Called when the node enters the scene tree for the first time.

onready var jumpTimer: Timer = $JumpTimer


func _ready() -> void:
	set_process(false)


func set_controller_id(value: int)-> void:
	controller_id = value
	set_process(controller_id != -1)


func _process(delta: float) -> void:
	var horz_velocity: float = 0.0
	var vert_velocity: float = 0.0
	
	# Horz Movement
	horz_velocity = sign(Input.get_joy_axis(controller_id, JOY_ANALOG_LX))
	if horz_velocity:
		velocity.x += HORZ_VELOCITY * delta
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	# Vert Movement
	# If jump is ready and B pressed 
	if jump_ready and Input.is_joy_button_pressed(controller_id, JOY_XBOX_B):
		velocity.y -= JUMP_VELOCITY * delta
		set_jump_ready(false)
	velocity.y += (gravity * delta)
	
	var clamped_x: float = clamp(velocity.x, -MAX_HORZ_VELOCITY, MAX_HORZ_VELOCITY)
	var clamped_y: float = clamp(velocity.y, -MAX_JUMP_VELOCITY, MAX_JUMP_VELOCITY)
	#print(clamped_y)
	velocity = Vector2(clamped_x, clamped_y)
	global_position += move_and_slide(velocity, Vector2.UP, false, 4, deg2rad(60))


func set_jump_ready(value: bool)-> void:
	jump_ready = value
	if !jump_ready:
		jumpTimer.start(jump_cooldown_dur)

func _jump_ready()-> void:
	set_jump_ready(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
