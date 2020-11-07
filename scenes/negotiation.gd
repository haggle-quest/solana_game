extends Node


#onready var NPC_AI_position = $NPC_AI_position
onready var player = $player_character
var NPC_AI_scene = preload("res://scenes/NPC_AI.tscn")

# Saved weights for AI
const MODEL_FILE_NAME = "res://cfr_plus_new_payoffs_2000.json"
onready var model_weights

var agents
# Seller always goes first
const seller_id = 0
const buyer_id = 1

func load_model_from_file():
	var model_file = File.new()
	model_file.open(MODEL_FILE_NAME, File.READ)
	model_weights = parse_json(model_file.get_as_text())
	print(model_weights['1 Ask_10'])
	print(model_weights['1 Ask_10'].keys())
	print(model_weights['1 Ask_10'].values())

func _ready():
	load_model_from_file()
	for i in range(1,100):
		print("New NPC")
		yield(get_tree().create_timer(2.0), "timeout")
		var npc_ai = NPC_AI_scene.instance()
		npc_ai.model_weights = model_weights
		add_child(npc_ai)
		agents = [npc_ai, player]
		yield(start_negotiation(agents), "completed")
		npc_ai.queue_free()
	pass
#	npc_ai.queue_free() 

func start_negotiation(agents):
	var offers := []
	var this_offer
	var this_actor = 0
	var num_turns = 0
	while num_turns < 3:
#		yield(get_tree().create_timer(2.0), "timeout")
		
		this_offer = yield(agents[this_actor].make_offer(offers), "completed")
		print("Offer: ", this_offer)
		offers.append(this_offer)

#		this_offer = agents[this_actor].current_offer
		if [0, 22].has(this_offer):
			return
		elif [21].has(this_offer):
			# Deal accepted
			agents[seller_id].close_deal(this_offer, seller_id)
			agents[buyer_id].close_deal(this_offer, buyer_id)
			return
		
		num_turns += 1
		this_actor = (this_actor + 1) % 2
#		print("Value of this: ", this)
	yield(get_tree().create_timer(3.0), "timeout")
	# TODO call a function that transfers items and objects


