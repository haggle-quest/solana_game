extends Button

export(String, FILE, "*.tscn") var scene_to_load
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#func _process(delta):
#	pass


func _on_main_menu_button_pressed():
	get_tree().change_scene(scene_to_load)
