extends HSlider

onready var make_offer = $"../player_action/make_offer"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	make_offer.text = """Offer: """ + str(10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_offer_slider_value_changed(value):
	if not make_offer.disabled:
		make_offer.text = """Offer: """ + str(value)
