extends ColorRect

signal fade_finished

func fade_in():
	$fade_in_animation.play("fade_in")
	



func _on_fade_in_animation_animation_finished(anim_name):
	emit_signal("fade_finished")
