extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $VBoxContainer/CenterContainer/VBoxContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)

	pass # Replace with function body.
