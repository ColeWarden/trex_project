extends KinematicBody2D

enum STATE {
	HONK,
	HIDE,
	JUMP,
	SHOW,
}

const ANIMATION_STATES: Array = ["honk", "hide", "jump", "slam"]
var state: int = STATE.HONK
var players: Array = []
#var first_player: Player = null
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 10.0
var timer: int = 0
var friction: float = 100.0
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.playback_speed = 10.0
	animationPlayer.play("honk")


func _area_entered(area: Area2D) -> void:
	var first_player = area.get_parent()
	players.append(first_player)
	set_state(STATE.HONK)

func _process(_delta: float) -> void:
	if players.size() < 1:
		return
	var closest_dist: float = 100000.0
	var closest_player: Player = null
	for player in players:
		#print(players)
		var dist = player.global_position.distance_to(global_position)
		if closest_dist > dist:
			closest_dist = dist
			closest_player = player
	velocity.x += global_position.direction_to(closest_player.global_position).normalized().x * 100.0
	
	velocity.x = clamp(velocity.x, -250, 250)
	face_player(closest_player)
	if !is_on_floor():
		velocity.y += gravity
	
	var _e = move_and_slide(velocity, Vector2.UP, false)


func set_animation(_state: int)-> void:
	animationPlayer.play(ANIMATION_STATES[_state])


func set_state(new_state: int)-> void:
	state = new_state
#	if state == STATE.HONK:
#		animationPlayer.play("honk")
#	elif state == STATE.HIDE:
#		animationPlayer.play("hide")
#	elif state == STATE.JUMP:
#		animationPlayer.play("jump_up")
#	elif state == STATE.SHOW:
#		in_air = -1
		#to_pos = first_player.global_position + Vector2(0, -96)
		#animationPlayer.play("show")

#
#func _jump()-> void:
#	velocity.y = -400
#	global_position.y -= 10
#	#in_air = 10


func face_player(closest_player)-> void:
	if closest_player:
		var player_pos: Vector2 = closest_player.global_position
		$Sprite.flip_h = player_pos.x > global_position.x


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	pass
#	print(anim_name)
#	if anim_name == "jump_up":
#		return
#	set_state((state + 1) % 3) + 1)


func _on_DetectionArea_area_exited(area: Area2D) -> void:
	var first_player = area.get_parent()
	players.erase(first_player)
