extends Node2D

# warning-ignore:unused_class_variable
var is_shaded = false
# warning-ignore:unused_class_variable
var colorblind_shader = preload('res://addons/paulloz.colorblindness/colorblindness.material')

func _ready():
	$Colorblindness/Colorblindness.set_type(Global.colorblind_filter)
	
	set_process(true)
	# Reseting the global variables as the game starts
	
	$HighScore.text = str("High Score: \n", Global.high_score)
	
	# Receiving signal from player to authorize a new scenario to spawn
# warning-ignore:return_value_discarded
	$Player.connect('add_scenario', $Scenarios, '_add_new_scenario')
# warning-ignore:return_value_discarded
	$Player.connect('player_lost', $StartTimer, '_on_player_lost')
# warning-ignore:return_value_discarded
	get_node("Scenarios/" + Global.node_name).connect('send_index', $Player, '_get_skin_index')
	pass

# warning-ignore:unused_argument
func _process(delta):
	$StartTimer/GUI/UI/TopBar/points_label.text = str($Player.points)
	
	# If player collided with an item, get the name of the instance and send the item color index
	if Global.collided:
# warning-ignore:return_value_discarded
		get_node("Scenarios/" + Global.node_name).connect('send_index', $Player, '_get_skin_index')
		Global.collided = false
		pass
	# If player collided with a transparent item, do the same as above but sending different parameters
	if Global.collision_exception:
# warning-ignore:return_value_discarded
		get_node("Scenarios/" + Global.node_name).connect('send_index', $Player, '_get_skin_index')
		Global.collision_exception = false
		pass
	
	# If press enter reload game scene
	if Input.is_action_just_pressed("ui_accept"):
		Global._reset()
		yield(get_tree().create_timer(0.05), "timeout")
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		pass
	pass
