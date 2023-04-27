extends InputInteractable

onready var drB: Sprite = $Sprite/DrB
onready var drawNode2D: Node2D = $CanvasLayer/Node2D
var active: bool = false
var win_screen: bool = false
var width: float = 64.0
var c: float = 0.0


# Override
func receive_active(_value)-> void:
	active = true
	$AnimationPlayer.play("default")


func set_color_mode(color: int)-> void:
	pass


func bouvier_dance()-> void:
	$Timer.start()
	win_screen = true
	$CanvasLayer/Particles2D.emitting = true
	$CanvasLayer/Label.rect_rotation = 0
	


func _process(delta: float) -> void:
	if !win_screen:
		return
	c += delta
	#$CanvasLayer/Label.rect_rotation = 0
	$CanvasLayer/Label.rect_rotation = sin(c * 7.0) * 5
	var s = ((sin(c * 2.0) + 1.0) / 2.0) 
	s /= 3
	s += 1.0
	$CanvasLayer/Label.rect_scale = Vector2(s,s)
	$CanvasLayer/Label.visible_characters += 1


func _on_Timer_timeout() -> void:
	drB.frame = (drB.frame + 1) % drB.hframes
