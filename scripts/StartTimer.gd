extends Control

var clicked = false

func _ready():
	Global._load("value", "valueOne")
	get_tree().paused = true
	set_process_input(true)

func _on_player_lost():
	Global._save("value", "valueOne")
	get_tree().paused = true
	$GUI/GameOver.popup()
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_click") or event is InputEventScreenTouch or event.is_action_pressed("ui_lost_reset"):
		if !clicked:
			$HBoxContainer.queue_free()
			get_tree().paused = false
			clicked = true
			pass
		pass
	
	if get_tree().paused and clicked:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_click") or Input.is_action_just_pressed("ui_lost_reset") or event is InputEventScreenTouch:
			Global._reset()
			yield(get_tree().create_timer(1), "timeout")
# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
	pass