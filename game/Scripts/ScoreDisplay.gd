extends Label
class_name score_display

func _ready():
	set_score(400)

func set_score(score : int):
	text = score as String
