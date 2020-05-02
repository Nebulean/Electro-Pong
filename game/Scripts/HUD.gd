extends Control

onready var scorep1 := $MarginContainer/ScoreP1
onready var scorep2 := $MarginContainer/ScoreP2

func set_score_p1(score: int) -> void:
	scorep1.set_score(score)

func set_score_p2(score: int) -> void:
	scorep2.set_score(score)
