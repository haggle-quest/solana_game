extends MarginContainer

export(bool) var anim_is_playing
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_player = $TextureRect/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if anim_is_playing:
		play_bouncing_anim()
	pass

func play_bouncing_anim():
	anim_player.play("bounce_while_waiting")
	$Loading.show()

func stop_bouncing_anim():
#	yield(anim_player, "animation_finished")
	anim_player.stop()
	$Loading.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
