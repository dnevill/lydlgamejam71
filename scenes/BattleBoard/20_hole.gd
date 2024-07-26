extends Sprite2D
class_name Hole20

var hole_is_open = true

## Toggles all collisions with the exception of layer 8, the 'in the hole' layer
func toggle_collision():
	#print("The hole is switching from " + str(hole_is_open))
	await get_tree().create_timer(0.1).timeout
	if hole_is_open:
		$StaticBody2D.set_collision_layer_value(1, false)
		$StaticBody2D.set_collision_mask_value(1, false)
		$StaticBody2D.set_collision_mask_value(4, false)
		$StaticBody2D.set_collision_mask_value(5, false)
		$Area2D.set_collision_layer_value(1, false)
		$Area2D.set_collision_mask_value(1, false)
		$Area2D.set_collision_mask_value(4, false)
	else:
		$StaticBody2D.set_collision_layer_value(1, true)
		$StaticBody2D.set_collision_mask_value(1, true)
		$StaticBody2D.set_collision_mask_value(4, true)
		$StaticBody2D.set_collision_mask_value(5, true)
		$Area2D.set_collision_layer_value(1, true)
		$Area2D.set_collision_mask_value(1, true)
		$Area2D.set_collision_mask_value(4, true)
	hole_is_open = not hole_is_open
	#print("Hole layer mask: " + str($StaticBody2D.collision_layer) + " " + str($StaticBody2D.collision_mask))

