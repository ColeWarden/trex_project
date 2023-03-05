class_name Checkpoint
extends Node2D


var current_checkpoint: bool = false

func _ready() -> void:
	pass # Replace with function body.


func set_current_checkpoint()-> void:
	var checkpoints: Array = get_group_nodes("checkpoint")
	for checkpoint in checkpoints:
		checkpoint.current_checkpoint = false
		checkpoint.modulate.a = 1.0
	current_checkpoint = true
	modulate.a = 4.0


func get_group_nodes(group: String)-> Array:
	return get_tree().get_nodes_in_group(group)


func _on_HurtArea_area_entered(area: Area2D) -> void:
	set_current_checkpoint()
