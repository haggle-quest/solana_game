extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var issue_title setget set_issue_title
var num_votes setget set_num_votes
var issue_number

signal voted

func set_issue_title(value):
	$IndividualIssue/issue_title.text = value

func set_num_votes(value):
	$IndividualIssue/number_votes.text = "VOTES\n\r%s" % value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_vote_button_pressed():
	emit_signal("voted")

