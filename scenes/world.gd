extends Node2D

var starting_pos: Vector2 = Vector2(400, 64)
var devices: Array = []
onready var packedPlayer: PackedScene = preload("res://scenes/player/Player.tscn")


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


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#	for device in devices:
#		print(device, ": ", sign(Input.get_joy_axis(device, JOY_ANALOG_LX)))
	#var horz_velocity = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	#print(horz_velocity)

#func _input(event: InputEvent) -> void:
#	print(event)
