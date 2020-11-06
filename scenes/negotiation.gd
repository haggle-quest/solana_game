extends Node


#onready var NPC_AI_position = $NPC_AI_position
onready var player = $player_character
var NPC_AI_scene = preload("res://scenes/NPC_AI.tscn")

var agents
# Seller always goes first
const seller_id = 0
const buyer_id = 1

func _ready():
	for i in [1,2]:
		yield(get_tree().create_timer(2.0), "timeout")
		var npc_ai = NPC_AI_scene.instance()
		add_child(npc_ai)
		agents = [npc_ai, player]
		yield(start_negotiation(agents), "completed")
		npc_ai.queue_free()
	pass
#	npc_ai.queue_free() 

func start_negotiation(agents):
	var offers := PoolStringArray()
	var this_offer
	var this_actor = 0
	var num_turns = 0
	while num_turns < 3:
#		yield(get_tree().create_timer(2.0), "timeout")
		
		this_offer = yield(agents[this_actor].make_offer(offers), "completed")
		print("Offer: ", agents[this_actor].current_offer)

		this_offer = agents[this_actor].current_offer
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
	# TODO call a function that transfers items and objects


