class_name InputInteractable
extends Interactable

"""
Input interactable recieve key from Output interactable; is used for doors, platforms, etc...
"""

export(String) var input_key: String


func init() -> void:
	.init()
	add_to_group(input_key)


# Override, called by output_interactables
func receive_active(_value)-> void:
	pass

