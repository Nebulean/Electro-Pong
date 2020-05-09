extends Control

onready var scorep1 := $MarginContainer/ScoreP1
onready var scorep2 := $MarginContainer/ScoreP2
onready var victory := $VictoryText

func _on_game_starts():
	victory.visible = false

func set_score_p1(score: int) -> void:
	scorep1.set_score(score)

func set_score_p2(score: int) -> void:
	scorep2.set_score(score)

func _on_player_won(player) -> void:
	victory.text = "Player %d won !" % player
	victory.visible = true
	
