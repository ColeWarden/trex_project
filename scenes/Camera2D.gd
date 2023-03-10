extends Camera2D

var players: Array = []

export var decay = 0.8  
export var max_offset = Vector2(100, 75)  
export var max_roll = 0.1  

var trauma = 0.0  
var trauma_power = 2 
 
#var to_pos: Vector2 = Vector2.ZERO

onready var hurtAreas: Array = [$HurtArea, $HurtArea2, $HurtArea3, $HurtArea4]


func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	if players.empty():
		players = get_group_nodes("player")
		return
	
	var local_pos: Vector2 = Vector2.ZERO
	for player in players:
		var player_pos: Vector2 = player.global_position
		local_pos.y += player_pos.y
		if local_pos.x < player_pos.x:
			local_pos.x = player_pos.x
	local_pos.y = local_pos.y / players.size()

	
	global_position = lerp(global_position, local_pos, delta * 3.0)
	global_position.x = max(global_position.x, 320)


func set_shake_power(power: float)-> void:
	trauma = power


func shake()-> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)


func _ready() -> void:
	set_hurt_boundaries_active(false)


func set_hurt_boundaries_active(value: bool)-> void:
	for hurtArea in hurtAreas:
		hurtArea.monitorable = value


func get_group_nodes(group: String)-> Array:
	return get_tree().get_nodes_in_group(group)
