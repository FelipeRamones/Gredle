extends Node2D

var next_spawn_x_position = 0

var scenario = preload('res://scenes/scenarios/ScenarioBase.tscn')

func _ready():
	_add_new_scenario()
	pass

func _instance_scenario():
	var scenario_info = scenario.instance()
	return scenario_info
	pass

func _add_new_scenario():
	var scenario = _instance_scenario()
	next_spawn_x_position += 1536
	scenario.position.x = next_spawn_x_position
	add_child(scenario)
	pass
