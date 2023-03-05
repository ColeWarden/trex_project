extends Node2D

const packedProjectile: PackedScene = preload("res://scenes/projectile/Projectile.tscn")

var starting_pos: Vector2 = Vector2(400, 64)
var devices: Array = []

onready var packedPlayer: PackedScene = preload("res://scenes/player/Player.tscn")
onready var ySort: YSort = $YSort


func _ready() -> void:
	devices = Input.get_connected_joypads()
	if devices.empty():
		var inst: Node2D = packedPlayer.instance()
		add_child(inst)
		inst.set_controller_id(-1)
		inst.global_position = starting_pos
	else:
		var inst: Node2D = packedPlayer.instance()
		add_child(inst)
		inst.set_controller_id(devices[0])
		inst.global_position = starting_pos


func get_ySort()-> YSort:
	return ySort


func create_projectile(direction: Vector2, spd: float)-> Projectile:
	var inst: Projectile = packedProjectile.instance()
	ySort.add_child(inst)
	inst.set_direction(direction)
	inst.set_speed(spd)
	return inst


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#	for device in devices:
#		print(device, ": ", sign(Input.get_joy_axis(device, JOY_ANALOG_LX)))
	#var horz_velocity = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	#print(horz_velocity)

#func _input(event: InputEvent) -> void:
#	print(event)
