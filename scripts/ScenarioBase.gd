extends Node2D

# Preloading the images for the items sprites
# warning-ignore:unused_class_variable
var green_item = preload('res://animations/Items/ItemGreen.tres')
# warning-ignore:unused_class_variable
var red_item = preload('res://animations/Items/ItemRed.tres')
# warning-ignore:unused_class_variable
var purple_item = preload('res://animations/Items/ItemPurple.tres')
var blank_item = preload('res://animations/Items/ItemBlank.tres')

# Preloading the images for the scenarios sprites
# warning-ignore:unused_class_variable
var green_background = preload('res://sprites/scenario/scenario_green.png')
# warning-ignore:unused_class_variable
var red_background = preload('res://sprites/scenario/scenario_red.png')
# warning-ignore:unused_class_variable
var purple_background = preload('res://sprites/scenario/scenario_purple.png')

# Creating an array of possible background sprites
var background_sprites = [green_background, red_background, purple_background]
# Variable keep the last spawned scenario sprite stored
var selected_background_sprite

# Signal to send the index of the item color to the player
signal send_index

# To get an index out of a value
var index_dictionary = {green_item : 0, red_item : 1, purple_item : 2, blank_item : null}

# To get an index out of a background value
var background_index_dictionary = {green_background : 0, red_background : 1, purple_background : 2}

# To randomize sprites
var item_sprites = [green_item, red_item, purple_item]

func _ready():
	if Global.flat_backgrounds:
		green_background = preload('res://sprites/scenario/scenario_green_flat.png')
		# warning-ignore:unused_class_variable
		red_background = preload('res://sprites/scenario/scenario_red_flat.png')
		# warning-ignore:unused_class_variable
		purple_background = preload('res://sprites/scenario/scenario_purple_flat.png')
		
		background_sprites = [green_background, red_background, purple_background]
		
		background_index_dictionary = {green_background : 0, red_background : 1, purple_background : 2}
	randomize()
	
	# A background sprite will be picked
	selected_background_sprite = floor(rand_range(0, floor(background_sprites.size())))
	# If this background color is the same as the previous all the itens get tranparent sprites
	if(Global.previous_background_texture == selected_background_sprite):
		Global.scenario_repeat += 1
		if Global.scenario_repeat == 2:
			Global.is_scenario_repeat = true
		if Global.scenario_repeat >= 3:
			Global.scenario_repeat = 1
			Global.is_scenario_repeat = false
			while Global.previous_background_texture == selected_background_sprite:
				selected_background_sprite = floor(rand_range(0, floor(background_sprites.size())))
		else:
			$SwitchAreas/Switch1/AnimatedSprite.frames = blank_item
			$SwitchAreas/Switch2/AnimatedSprite.frames = blank_item
			$SwitchAreas/Switch3/AnimatedSprite.frames = blank_item
		pass
	# Else shuffles the array of item sprites and apply then to the itens
	else:
		Global.is_scenario_repeat = false
		Global.scenario_repeat = 1
		item_sprites.shuffle()
		
		$SwitchAreas/Switch1/AnimatedSprite.frames = item_sprites[0]
		$SwitchAreas/Switch2/AnimatedSprite.frames = item_sprites[1]
		$SwitchAreas/Switch3/AnimatedSprite.frames = item_sprites[2]
	
	# Send the selected scenario sprite to the global script to control what was the previous sprite
	Global.previous_background_texture = selected_background_sprite
	
	# Applying the selected sprite to the background
	$Background.texture = background_sprites[selected_background_sprite]
	
	Global.next_scenario = background_index_dictionary[$Background.texture]
	
	# Sending it's name to the glabal script in order to connect the signal later
	Global.node_name = self.name
	
	# Send null value thru signal just to connect
	emit_signal("send_index", null, null)
	
	print("Variable is_scenario_repeat: ", Global.is_scenario_repeat, "\nVariable scenario_repeat: ", Global.scenario_repeat)

# When player collides with item 1
# warning-ignore:unused_argument
func _on_Switch1_body_entered(player):
	# Set's collision boolean checker in global script
	Global._on_colision_detection()
	# emits the signal with the index of this item color
	emit_signal("send_index", index_dictionary[$SwitchAreas/Switch1/AnimatedSprite.frames], background_index_dictionary[$Background.texture])
	# Call a method to destroy the colliders in this scene to prevent hitting two items or hit the same twice
	_destroy_items_collision()
	pass 

# When player collides with item 2
# warning-ignore:unused_argument
func _on_Switch2_body_entered(player):
	# Set's collision boolean checker in global script
	Global._on_colision_detection()
	# emits the signal with the index of this item color
	emit_signal("send_index", index_dictionary[$SwitchAreas/Switch2/AnimatedSprite.frames], background_index_dictionary[$Background.texture])
	# Call a method to destroy the colliders in this scene to prevent hitting two items or hit the same twice
	_destroy_items_collision()
	pass 

# When player collides with item 3
# warning-ignore:unused_argument
func _on_Switch3_body_entered(player):
	# Set's collision boolean checker in global script
	Global._on_colision_detection()
	# emits the signal with the index of this item color
	emit_signal("send_index", index_dictionary[$SwitchAreas/Switch3/AnimatedSprite.frames], background_index_dictionary[$Background.texture])
	# Call a method to destroy the colliders in this scene to prevent hitting two items or hit the same twice
	_destroy_items_collision()
	pass 

# Method to destroy the item colliders
func _destroy_items_collision():
	$SwitchAreas/Switch1/CollisionShape2D.queue_free()
	$SwitchAreas/Switch2/CollisionShape2D.queue_free()
	$SwitchAreas/Switch3/CollisionShape2D.queue_free()
	pass

# Destroys this scenario when it exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	pass
