extends Node

# To know if the game scenarios colors  are flat or striped
# warning-ignore:unused_class_variable
var flat_backgrounds = false

# Value to start variable node name (stores the name of the node to connect)
var node_name = "ScenarioBase"
# Variable to receive true if player collided of false if not
var collided
# If player collided a transparent texture receives true
# warning-ignore:unused_class_variable
var collision_exception

# Stores the actual background sprite texture
var previous_background_texture

# warning-ignore:unused_class_variable
var high_score = 0

# Increase by 1 every time a scenario repeats and turns 1 otherwise
# warning-ignore:unused_class_variable
var scenario_repeat = 1
var is_scenario_repeat = false

var next_scenario = 3

# warning-ignore:unused_class_variable
var colorblind_filter = 0

# Function called to reset all the variables when scene reload
func _reset():
	node_name = "ScenarioBase"
	collided = null
	previous_background_texture = null
	is_scenario_repeat = false
	pass

# Function called to set collided to true
func _on_colision_detection():
	collided = true
	pass


#################### SAVE SYSTEM ##################################

var save_path = "user://save-file.cfg"
var config = ConfigFile.new()
# warning-ignore:unused_class_variable
var load_response = config.load(save_path)

func _save(section, key):
	config.set_value(section, key, high_score)
	config.save(save_path)
	pass

func _load(section, key):
	high_score = config.get_value(section, key, high_score)
	pass