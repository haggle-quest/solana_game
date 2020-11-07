extends Node


#onready var NPC_AI_position = $NPC_AI_position
onready var player = $player_character
#var NPC_AI_scene = preload("res://scenes/NPC_AI.tscn")
onready var npc_ai = $npc

onready var offers_label = $UI/Offers

# Saved weights for AI
const MODEL_FILE_NAME = "res://cfr_plus_new_payoffs_2000.json"
onready var model_weights

var agents
# Seller always goes first
const seller_id = 0
const buyer_id = 1

func load_model_from_file(model_file_name):
	var model_file = File.new()
	model_file.open(model_file_name, File.READ)
	model_weights = parse_json(model_file.get_as_text())
	print(model_weights['1 Ask_10'])
	print(model_weights['1 Ask_10'].keys())
	print(model_weights['1 Ask_10'].values())

func _ready():
	# Only need to load and add weights once
	load_model_from_file(MODEL_FILE_NAME)
	npc_ai.model_weights = model_weights
	for i in range(1,100):
		print("New NPC")

#		var npc_ai = NPC_AI_scene.instance()
		npc_ai.init_npc()
		agents = [npc_ai, player]
		yield(start_negotiation(agents), "completed")
		yield(get_tree().create_timer(2.0), "timeout")
#		npc_ai.queue_free()
	pass
#	npc_ai.queue_free() 

func start_negotiation(agents):
	var offers := []
	var this_offer
	var this_actor = 0
	var num_turns = 0
	while num_turns < 4:
#		yield(get_tree().create_timer(2.0), "timeout")
		
		this_offer = yield(agents[this_actor].make_offer(offers), "completed")
		print("Offer: ", this_offer)
		offers.append(this_offer)

#		this_offer = agents[this_actor].current_offer
		if this_offer == 22:
			offers_label.text = offers_label.text + "\n\r\n\rRejected >:0"
			return
		elif this_offer == 21:
			# Deal accepted
			offers_label.text = offers_label.text + "\n\r\n\rAccepted :)"
			agents[seller_id].close_deal(this_offer, seller_id)
			agents[buyer_id].close_deal(this_offer, buyer_id)
			return
		var offers_text = get_offers_text(offers)
		offers_label.text = offers_text
		num_turns += 1
		this_actor = (this_actor + 1) % 2
#		print("Value of this: ", this)
	yield(get_tree().create_timer(1.0), "timeout")


func get_offers_text(offers):
	var out_text
	if len(offers) >= 1:
		out_text = "NPC Asked For: " + str(offers[0])
	if len(offers) >= 2:
		out_text += "\n\r\n\rPlayer Offered: " + str(offers[1])
	if len(offers) >= 3:
		out_text += "\n\r\n\rNPC Asked For: " + str(offers[2])
	return out_text
