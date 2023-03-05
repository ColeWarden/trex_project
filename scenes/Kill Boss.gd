extends InputInteractable





# Override, called by output_interactables
func receive_active(_value)-> void:
	var boss: Array = get_tree().get_nodes_in_group("boss")
	print(boss)
	if boss.empty():
		return
	boss.front().queue_free()


