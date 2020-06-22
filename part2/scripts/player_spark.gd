extends KinematicBodyBase2D

func _on_touchSelect_pressed():
	get_tree().set_group("characters", "controlled", false)
	yield(get_tree().create_timer(.1), "timeout")
	self.controlled = true

func _input(event):
	if person == "robo":
		if event is InputEventKey:
			if event.is_pressed():
				if event.scancode == KEY_D:
					self.die()
