extends Camera2D

var players: Array = []
onready var hurtAreas: Array = [$HurtArea, $HurtArea2, $HurtArea3, $HurtArea4]



func _ready() -> void:
	set_hurt_boundaries_active(false)


func set_hurt_boundaries_active(value: bool)-> void:
	for hurtArea in hurtAreas:
		hurtArea.monitorable = value


func get_group_nodes(group: String)-> Array:
	return get_tree().get_nodes_in_group(group)


func _process(delta: float) -> void:
	if players.empty():
		players = get_group_nodes("player")
		return
	
	var to_pos: Vector2 = Vector2.ZERO
	for player in players:
		var player_pos: Vector2 = player.global_position
		if to_pos.x < player_pos.x:
			to_pos = player_pos
	
	global_position = to_pos
