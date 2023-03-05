extends InputInteractable

onready var drB: Sprite = $Sprite/DrB
onready var drawNode2D: Node2D = $CanvasLayer/Node2D
var active: bool = false
var win_screen: bool = false
var width: float = 64.0


func _ready() -> void:
	$AnimationPlayer.play("default")


# Override
func receive_active(_value)-> void:
	active = true


func bouvier_dance()-> void:
	$Timer.start()
	win_screen = true


func _process(delta: float) -> void:
	if !win_screen:
		return

func _on_Timer_timeout() -> void:
	drB.frame = (drB.frame + 1) % drB.hframes
