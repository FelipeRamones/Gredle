extends Control

var is_playing_music = false
var is_playing_fx = false
var i = 0
var types = ['Nenhum', 'Protanopia', 'Deuteranopia', 'Tritanopia', 'Achromatopsia']

# warning-ignore:unused_argument
func _on_CheckButton_toggled(button_pressed):
	if !Global.flat_backgrounds:
		Global.flat_backgrounds = true
	elif Global.flat_backgrounds:
		Global.flat_backgrounds = false


func _on_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene('res://scenes/TitleScreen.tscn')


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_HSlider_focus_entered():
	if !is_playing_music:
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.stream_paused = false
		is_playing_music = true


func _on_HSlider_focus_exited():
	$AudioStreamPlayer.stream_paused = true
	is_playing_music = false


func _on_HSlider2_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)


func _on_HSlider2_focus_entered():
	if !is_playing_fx:
		$AudioStreamPlayer2.play()
		$AudioStreamPlayer2.stream_paused = false
		is_playing_fx = true


func _on_Button2_pressed():
	if $Colorblindness.Type < 4:
		i += 1
		$Colorblindness.set_type(i)
		
	else:
			i = 0
			$Colorblindness.set_type(i)
			
	print($Colorblindness.Type)
	Global.colorblind_filter = i
	$Menu/CenterRow/Buttons/Button2.text = str(types[i]).to_upper()