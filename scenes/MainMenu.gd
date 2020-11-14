extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var keypair_file_path = "user://keypair.json"

onready var cute_character = $VBoxContainer/cute_character

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $VBoxContainer/CenterContainer/VBoxContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		pass # Replace with function body.
	var file_check = File.new()
	var does_file_exist = file_check.file_exists(keypair_file_path)
	if does_file_exist:
		on_create_account_finished()

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

func on_create_account_finished():
	cute_character.stop_bouncing_anim()
	$VBoxContainer/CenterContainer/VBoxContainer/Start_game_button2.disabled = false
	$VBoxContainer/CenterContainer/VBoxContainer/Feature_request_voting.disabled = false
	print("http request done")
