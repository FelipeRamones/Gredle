extends Control

func _ready():
	$Colorblindness.set_type(Global.colorblind_filter)

func _on_Play_button_down():
# warning-ignore:return_value_discarded
	get_tree().change_scene('res://scenes/RunnerGame.tscn')

func _on_Play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene('res://scenes/RunnerGame.tscn')
	pass


func _on_Settings_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene('res://scenes/OptionsScreen.tscn')
