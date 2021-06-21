extends KinematicBody2D


var speed = 200
var direction = Vector2()
var owner_id = 0

func set_id(id):
	owner_id = id

func get_id():
	return owner_id


# warning-ignore:shadowed_variable
remote func _update_client_position(direction):
	direction = direction.normalized()
	if(direction != Vector2()):
# warning-ignore:return_value_discarded
		if(owner_id == get_tree().get_rpc_sender_id()):
			move_and_slide(direction*speed)
		
		rpc_unreliable("_apply_pos", global_transform.origin)
