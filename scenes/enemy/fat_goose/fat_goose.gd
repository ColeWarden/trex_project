extends KinematicBody2D

enum STATE {
	IDLE,
	HONK,
	HIDE,
	JUMP,
	SHOW,
}

const ANIMATION_STATES: Array = ["honk", "hide", "jump", "slam"]
var state: int = STATE.IDLE
var first_player: Player = null
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 10.0

onready var animationPlayer: AnimationPlayer = $AnimationPlayer


func _area_entered(area: Area2D) -> void:
	first_player = area.get_parent()


func _process(delta: float) -> void:
	velocity.y += gravity
	move_and_slide(velocity, Vector2.UP, false)
	
	if state == STATE.IDLE:
		honk()


func honk():
	state = STATE.HONK
	set_animation(state)


func set_animation(_state: int)-> void:
	animationPlayer.play(ANIMATION_STATES[_state])
