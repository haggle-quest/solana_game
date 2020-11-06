extends Node2D

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var internal_value
var current_offer

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	internal_value = rng.randi_range(0,19)
	pass # Replace with function body.

func make_offer(offers):
#	print("Offerings: ", internal_value, offers.join(""))
	# A very cheesy hack to make sure the yield function in the parent function
	# has time to wait until the signal is emitted
	yield(get_tree().create_timer(0.25), "timeout")
	current_offer = internal_value
	return(current_offer)
#	return 1

func close_deal(offer, agent_id, quantity=1):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
