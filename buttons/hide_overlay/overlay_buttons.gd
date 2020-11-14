extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#   pass


func _on_main_menu_button_pressed():
	print("button clicked")
	get_tree().current_scene.find_node("PubPrivKeyOveraly").hide()
