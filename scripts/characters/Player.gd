extends KinematicBody2D

var speed_x = 350
var gravity = 2000

var direction = Vector2(0, 0)
var can_jump = false
var released_jump = false
var was_already_on_the_floor = false
var fall_when_release_jump_button = false

var is_falling = false

# To determine the player points
var points = 0

var time_for_points = 1

# Preloading player animations in different colors
# warning-ignore:unused_class_variable
var red = preload('res://animations/player_red.tres')
# warning-ignore:unused_class_variable
var green = preload('res://animations/player_green.tres')
# warning-ignore:unused_class_variable
var purple = preload('res://animations/player_purple.tres')
# warning-ignore:unused_class_variable
var black = preload('res://animations/player_black.tres')

# Storing the player animations in an anrray in the same order of the dictionary in scenario script
var colors = [green, red, purple, black]

func _ready():
	$dialog_box/Icon.texture = icons[Global.next_scenario]
	$time_to_spawn_dialog_box2.start()
	$time_to_spawn_dialog_box2.wait_time = 0.7
	set_process_input(true)
	$Camera2D/points_timer.wait_time = time_for_points
	pass

func _physics_process(delta):
	
	# Method to check if a new scenario must be spawned
	_authorize_new_scenario()
	
	direction.y += gravity * delta
	direction.x = speed_x
	direction = move_and_slide(direction, Vector2(0, -1))
	
	if is_on_floor():
		if is_falling:
			gravity /= 1.5
			is_falling = false
			pass
		if not was_already_on_the_floor:
			$AnimationLanded.play("smooth_landing")
			$LandingDust.visible = true
			$LandingDust/LandingDustAnimation.play("landing_dust")
			$landing_sound.play()
			pass
		$AnimatedSprite.play("run")
		if can_jump:
			_jump(1350, true)
			$jump_sound.play()
			pass
		pass
	else:
		$AnimatedSprite.play("jump")
		if released_jump and direction.y < 0 and fall_when_release_jump_button:
			direction.y *= 0.3
			pass
		_better_jump()
		pass
	was_already_on_the_floor = is_on_floor()
	can_jump = false
	released_jump = false
	pass

func _jump(force, fall_when_release_jump_button_intern):
	direction.y = -force
	fall_when_release_jump_button = fall_when_release_jump_button_intern
	pass

func _input(event):
	if event is InputEventScreenTouch or event is InputEventKey:
		if event.pressed:
			can_jump = true
			pass
		else:
			released_jump = true
		pass
	pass

func _better_jump():
	if direction.y > 0 and is_falling == false:
			gravity *= 1.5
			is_falling = true
			pass
	pass

# Variable to determine the distance the player must be to spawn the first scenario
var distance = 1500
# Signal to authorize a new scenario spawn
signal add_scenario

var icons = [
preload('res://sprites/UI/green_icon.png'),
preload('res://sprites/UI/red_icon.png'),
preload('res://sprites/UI/purple_icon.png')
]

# To be called when player position is greater than distance variable, and increment variable to keep spawning
func _authorize_new_scenario():
	if position.x >= distance:
		distance += 1536
		emit_signal("add_scenario")
		$dialog_box/Icon.texture = icons[Global.next_scenario]
		if !Global.is_scenario_repeat:
			$time_to_spawn_dialog_box2.start()
		pass
	pass

func _on_time_to_spawn_dialog_box2_timeout():
	$dialog_box.visible = true
	$time_to_kill_dialog_box.start()

func _on_time_to_kill_dialog_box_timeout():
	$dialog_box.visible = false

signal player_lost

# Method called by the collision signal to change player color to the same as the item he collided with
func _get_skin_index(item_index, scenario_index):
	if item_index == null:
		pass
	else:
		$switch_skin_sound.play()
		$AnimatedSprite.frames = colors[item_index]
		if item_index != scenario_index:
			if Global.high_score < points:
				Global.high_score = points
			$fail_sound.play()
			pass
	pass

func _on_SpeedUpTimer_timeout():
	if speed_x < 900:
		speed_x += 10
		if time_for_points >= 0.04:
			time_for_points -= 0.04
			$Camera2D/points_timer.wait_time = time_for_points
	print(speed_x)
	pass 


func _on_fail_sound_finished():
	emit_signal("player_lost")


func _on_points_timer_timeout():
	points += 2
	pass 
