extends Node2D

enum MODE {
	IDLE,
	RETRY,
}

const COOLDOWN_DEATH_DUR: float = 1.0
const packedProjectile: PackedScene = preload("res://scenes/projectile/Projectile.tscn")

var starting_pos: Vector2 = Vector2(100, 96+64)#Vector2(244*16, -66*16)## Vector2(3100, -1100)#Vector2(100, 96+64)#
var devices: Array = []
var mode: int = MODE.IDLE
var cooldown_death: bool = false

onready var packedPlayer: PackedScene = preload("res://scenes/player/Player.tscn")
onready var players: Array = []
onready var ySort: YSort = $YSort
onready var animationPlayer: AnimationPlayer = $CanvasLayer/AnimationPlayer

func start_game():
	set_player_pause_mode(Node.PAUSE_MODE_INHERIT)

func _ready() -> void:
#	$CollisionMap.visible = false;
	pause_mode = Node.PAUSE_MODE_PROCESS
	devices = Input.get_connected_joypads()
	devices.resize(2)
	var keyboard_index: int = -1
	for i in devices.size():
		var inst: Node2D = packedPlayer.instance()
		ySort.add_child(inst)
		if i == 0:
			inst.sprite.texture = load("res://resources/player/eddy.png")
		else:
			inst.sprite.texture = load("res://resources/player/rexy.png")
		if devices[i] == null:
			inst.set_controller_id(keyboard_index)
			devices[i] = keyboard_index
			keyboard_index -= 1
			
		else:
			inst.set_controller_id(devices[i])
		inst.global_position = starting_pos
		var _e = inst.connect("die", self, "_player_died")
		players.append(inst)
	set_player_pause_mode(Node.PAUSE_MODE_STOP)
	$CanvasLayer/AnimationPlayer.play("intro")
	init_interactable()


func init_interactable()-> void:
	var interactables: Array = get_group_nodes("interactable")
	for i in interactables:
		i.init()


func get_ySort()-> YSort:
	return ySort


func create_projectile(direction: Vector2, spd: float)-> Projectile:
	var inst: Projectile = packedProjectile.instance()
	ySort.add_child(inst)
	inst.set_direction(direction)
	inst.set_speed(spd)
	return inst


func _player_died(player_id: Player)-> void:
	player_id._die()
	set_player_pause_mode(Node.PAUSE_MODE_STOP)
	player_id.pause_mode = Node.PAUSE_MODE_PROCESS
	ySort.pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
	set_mode_retry()


func set_mode_retry()-> void:
	mode = MODE.RETRY
	cooldown_death = true
	$CooldownDeath.start(COOLDOWN_DEATH_DUR)
	animationPlayer.play("retry")
	#set_player_pause_mode(PAUSE_MODE_INHERIT)


func set_mode_idle()-> void:
	mode = MODE.IDLE
	animationPlayer.play("RESET")
	set_player_pause_mode(PAUSE_MODE_INHERIT)


func set_player_pause_mode(pause: int)-> void:
	#var players: Array = get_group_nodes("player")
	for player in players:
		player.pause_mode = pause


func get_group_nodes(group: String)-> Array:
	return get_tree().get_nodes_in_group(group)


func get_current_checkpoint()-> Checkpoint:
	var checkpoints: Array = get_group_nodes("checkpoint")
	for checkpoint in checkpoints:
		if checkpoint.current_checkpoint:
			return checkpoint
	return null

func _get_jump_input(controller_id)-> bool:
	if controller_id == -1:
		return Input.is_action_pressed("space") or Input.is_action_pressed("w")
	elif controller_id == -2:
		return Input.is_action_pressed("enter")
	elif controller_id != -1:
		return Input.is_joy_button_pressed(controller_id, JOY_XBOX_B) or Input.is_joy_button_pressed(controller_id, JOY_XBOX_A)
	return false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("f2"):
		#Respsawn at last checkpoint
		reset()
	
	if Input.is_action_just_pressed("`"):
		#Respsawn at last checkpoint
		var _e = get_tree().reload_current_scene()
	
	if mode == MODE.RETRY:
		if cooldown_death:
			return
		var entered: bool = false
		for id in devices:
			entered = _get_jump_input(id)
			if entered:
				reset()
				break
	


func reset()-> void:
	set_mode_idle()
	mode == MODE.IDLE
	animationPlayer.play("RESET")
	get_tree().paused = false
	var check: Checkpoint = get_current_checkpoint()
	var spawn_pos: Vector2 = starting_pos
	if check:
		spawn_pos = check.global_position
	
	for player in players:
		player.global_position = spawn_pos
		player.reset()


func _on_CooldownDeath_timeout() -> void:
	cooldown_death = false
