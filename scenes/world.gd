extends Node2D


var devices: Array = []
onready var packedPlayer: PackedScene = preload("res://scenes/player/Player.tscn")

func _ready() -> void:
	devices = Input.get_connected_joypads()
	for device in devices:
		var inst: Node2D = packedPlayer.instance()
		add_child(inst)
		inst.set_controller_id(device)
		inst.global_position = Vector2(64, 64)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#	for device in devices:
#		print(device, ": ", sign(Input.get_joy_axis(device, JOY_ANALOG_LX)))
	#var horz_velocity = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	#print(horz_velocity)

#func _input(event: InputEvent) -> void:
#	print(event)
