extends Node2D

var flat_black = preload('res://sprites/scenario/scenario_black_flat.png')

func _ready():
	if Global.flat_backgrounds:
		$Background.texture = flat_black
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass 
